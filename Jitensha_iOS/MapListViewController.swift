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

class MapListViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapMapView: MKMapView!
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        mapMapView.delegate = self;
        let places:NSMutableArray = PlacesService.sharedInstance.placesArray;
        for place in places {
            let placeObj: PlaceModel = place as! PlaceModel;
            let annotation = MKPointAnnotation()
            annotation.coordinate = placeObj.location.coordinate;
            annotation.title = place.name;
            annotation.subtitle = "";
            mapMapView.addAnnotation(annotation)
        }
        
    }
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        // this is where visible maprect should be set
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
}