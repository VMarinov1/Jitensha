//
//  PlacesListViewController.swift
//  Jitensha_iOS
//
//  Created by Vladimir Marinov on 04.06.16.
//  Copyright © 2016 Vladimir Marinov. All rights reserved.
//


import UIKit
import BXProgressHUD
import CoreLocation

class  PlacesListViewController: UITableViewController, CLLocationManagerDelegate {
    
    var currentLocation: CLLocation?;
    var locationManager: CLLocationManager?;
    var locationManagerIsStarted: Bool?;
    var refreshTimer: NSTimer?;
    var selectedPlace: PlaceModel?;
    
  
    // MARK: view delegates
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        if UserService.sharedInstance.isLoggedIn() == false {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.showLogin();
        }
        else {
            self.loadPlaces();
        }
        self.locationManagerIsStarted = false;
        self.startLocationManager();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action:#selector(PlacesListViewController.loadPlaces), forControlEvents: UIControlEvents.ValueChanged );
        self.refreshControl = refreshControl;
        self.title = "Places List";
        self.locationManagerIsStarted = false;
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlacesListViewController.showMap));
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Rent History", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlacesListViewController.showRentHistory));
        self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(PlacesListViewController.updatePostions), userInfo: nil, repeats:true);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == Constants.kShowRentPlaceSegueId) {
            let dest: RentViewController = segue.destinationViewController as! RentViewController;
            dest.selectedPlace = selectedPlace;
        }
    }
    /*!
     * @discussion Caller from Timer to update list in TableView
     * @param sender Timer
     */
    func updatePostions(){
        if self.locationManagerIsStarted == true {
            self.tableView.reloadData();
        }
    }

    // MARK: Actions
    /*!
     * @discussion Start Location Service if NOT started yet
     */
    func startLocationManager(){
        if(self.locationManager == nil){
            self.locationManager = CLLocationManager();
        }
        self.locationManager?.delegate = self;
        if self.locationManagerIsStarted == false {
            self.locationManager?.delegate = self;
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager?.distanceFilter = kCLDistanceFilterNone;
            self.locationManager?.requestWhenInUseAuthorization();
            self.locationManager?.startMonitoringSignificantLocationChanges();
            self.locationManager?.startUpdatingLocation();
            self.locationManagerIsStarted = true;
        }
    }
    func showRentHistory(){
        self.performSegueWithIdentifier(Constants.kShowRentHistorySegueId, sender: self);
    }

    /*!
     * @discussion Called when ShowMap button pressed
     */
    func showMap(){
        self.performSegueWithIdentifier(Constants.kShowMapSegueId, sender: self);
    }
    /*!
     * @discussion Load places from Server
     */
    func loadPlaces(){
        self.refreshControl?.beginRefreshing();
        BXProgressHUD.showHUDAddedTo(self.view);
        PlacesService.sharedInstance.loginPlacesWithCompletionHandler({ (error) in
            BXProgressHUD.hideHUDForView(self.view, animated: true);
            if ((error) != nil) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alert = UIAlertController(title: Constants.errorTitleResponse, message: error, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: Constants.dismissButtonLabel, style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    dispatch_async(dispatch_get_main_queue(),{
                        self.tableView.reloadData();
                    })
                })
            }
            self.refreshControl?.endRefreshing();
        })
    }
    /*!
     * @discussion Return text for actual distance
     * @param distance
     * @return element
     */
    func textForDistance(distance:Double) -> (String){
        var distanceString:String  = "";
        if distance >= 0{
            if(distance < Constants.MetersCutOff){
                distanceString = String(format:"(%.01f m.)", distance);
            }
            else {
                distanceString = String(format:"(%.01f km.)", (distance/Constants.MetersCutOff));
            }
        }
        return distanceString;
    }
    // MARK: Location Services
    /*!
     * @discussion Called on location service Failed
     * @param manager Location Manager
     * @param error Error description
     */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if self.locationManagerIsStarted == true{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let alert = UIAlertController(title: Constants.errorTitleResponse, message: nil, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Location Service Failed", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
        self.locationManagerIsStarted = false;
    }
    
    /*!
     * @discussion Caller from Timer to update list in TableView
     * @param sender Timer
     */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if self.locationManagerIsStarted == true {
            self.tableView.reloadData();
            if locations.count > 0{
                self.currentLocation = locations[0];
                self.locationManagerIsStarted = true;
            }
        }
        self.locationManagerIsStarted = true;
    }
    // MARK: TableViewController
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedPlace = PlacesService.sharedInstance.placesArray.objectAtIndex(indexPath.row) as? PlaceModel;
        self.performSegueWithIdentifier(Constants.kShowRentPlaceSegueId, sender: self);
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlacesService.sharedInstance.placesArray.count;
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaceLabelCell", forIndexPath: indexPath)
        let place: PlaceModel = PlacesService.sharedInstance.placesArray.objectAtIndex(indexPath.row) as! PlaceModel;
        cell.textLabel?.text = place.name;
        cell.detailTextLabel?.text = "";
        if self.currentLocation != nil {
            let distanceToUser: Double = place.location.distanceFromLocation(self.currentLocation!);
            cell.detailTextLabel?.text = self.textForDistance(distanceToUser) as String;
        }
        return cell
    }
}