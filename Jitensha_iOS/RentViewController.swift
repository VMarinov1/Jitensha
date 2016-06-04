//
//  RentViewController.swift
//  Jitensha_iOS
//
//  Created by Vladimir Marinov on 04.06.16.
//  Copyright © 2016 Vladimir Marinov. All rights reserved.
//
import UIKit
import MapKit

class RentViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mapMapView: MKMapView!
    
    internal var selectedPlace: PlaceModel!
    /*!
     * @discussion Called when Rent button pressed
     */
     @IBAction func rentNow(sender: AnyObject) {
        
    }
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = self.selectedPlace.name;
        mapMapView.delegate = self;
        let annotation = MKPointAnnotation()
        annotation.coordinate = selectedPlace.location.coordinate;
        annotation.title = selectedPlace.name;
        annotation.subtitle = "";
        mapMapView.addAnnotation(annotation);
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Rent History", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(RentViewController.showRentHistory));

        
    }
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        // this is where visible maprect should be set
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    func showRentHistory(){
        self.performSegueWithIdentifier(Constants.kShowRentHistorySegueId, sender: self);
    }
}