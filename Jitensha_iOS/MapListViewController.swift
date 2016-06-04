//
//  MapListViewController.swift
//  Jitensha_iOS
//
//  Created by Vladimir Marinov on 04.06.16.
//  Copyright © 2016 Vladimir Marinov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomPlaceAnnotation: MKPointAnnotation {
    var placeId: String!
}

class MapListViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapMapView: MKMapView!
    var selectedPlace: PlaceModel?;
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        mapMapView.delegate = self;
        let places:NSMutableArray = PlacesService.sharedInstance.placesArray;
        for place in places {
            let placeObj: PlaceModel = place as! PlaceModel;
            let annotation = CustomPlaceAnnotation()
            annotation.coordinate = placeObj.location.coordinate;
            annotation.title = place.name;
            annotation.subtitle = "";
            annotation.placeId = placeObj.id;
            mapMapView.addAnnotation(annotation)
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == Constants.kShowRentPlaceSegueId) {
            let dest: RentViewController = segue.destinationViewController as! RentViewController;
            dest.selectedPlace = selectedPlace;
        }
    }
    // MARK: MKMapViewDelegate
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        // this is where visible maprect should be set
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        let annotationView:MKAnnotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"loc");
        annotationView.canShowCallout = true;
        annotationView.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure);
        return annotationView;
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        let selected: CustomPlaceAnnotation = (view.annotation as? CustomPlaceAnnotation)!;
        let places: NSMutableArray =  PlacesService.sharedInstance.placesArray;
        for place in places{
            let placeObject: PlaceModel = (place as? PlaceModel)!;
            if placeObject.id == selected.placeId {
                self.selectedPlace = placeObject;
                self.performSegueWithIdentifier(Constants.kShowRentPlaceSegueId, sender: self);
                break;
            }
        }
      
    }
    
}