//
//  LocationViewController.swift
//  TheBackgrounder
//
//  Created by Ray Fix on 12/9/14.
//  Copyright (c) 2014 Razeware, LLC. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController, CLLocationManagerDelegate {
  

  @IBOutlet weak var mapView: MKMapView!
  
  var locations = [MKPointAnnotation]()
  
  lazy var locationManager: CLLocationManager! = {
    let manager = CLLocationManager()
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.delegate = self
    manager.requestAlwaysAuthorization()
    return manager
  }()
  
  @IBAction func enabledChanged(sender: UISwitch) {
    if sender.on {
      locationManager.startUpdatingLocation()
    } else {
      locationManager.stopUpdatingLocation()
    }
  }
  
  @IBAction func accuracyChanged(sender: UISegmentedControl) {
    let accuracyValues = [
      kCLLocationAccuracyBestForNavigation,
      kCLLocationAccuracyBest,
      kCLLocationAccuracyNearestTenMeters,
      kCLLocationAccuracyHundredMeters,
      kCLLocationAccuracyKilometer,
      kCLLocationAccuracyThreeKilometers]
    
    locationManager.desiredAccuracy = accuracyValues[sender.selectedSegmentIndex];
  }
  
  // MARK: - CLLocationManagerDelegate
  
  func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
    // Add another annotation to the map.
    let annotation = MKPointAnnotation()
    annotation.coordinate = newLocation.coordinate
    mapView.addAnnotation(annotation)
    
    // Also add to our map so we can remove old values later
    locations.append(annotation)
    
    // Remove values if the array is too big
    while locations.count > 100 {
      let annotationToRemove = locations.first!
      locations.removeAtIndex(0)
      
      // Also remove from the map
      mapView.removeAnnotation(annotationToRemove)
    }
    
    if UIApplication.sharedApplication().applicationState == .Active {
      // determine the region the points span so we can update our map's zoom.
      var maxLat = -91.0
      var minLat =  91.0
      var maxLon = -181.0
      var minLon =  181.0
      
      for annotation in locations {
        let coordinate = annotation.coordinate;
        
        if coordinate.latitude > maxLat {
          maxLat = coordinate.latitude;
        }
        if coordinate.latitude < minLat {
          minLat = coordinate.latitude;
        }
        if coordinate.longitude > maxLon {
          maxLon = coordinate.longitude
        }
        if (coordinate.longitude < minLon) {
          minLon = coordinate.longitude
        }
      }
      
      let span = MKCoordinateSpan(latitudeDelta: (maxLat +  90) - (minLat +  90),
        longitudeDelta: (maxLon + 180) - (minLon + 180))

      let center = CLLocationCoordinate2D(latitude: minLat + span.latitudeDelta / 2,
        longitude:  minLon + span.longitudeDelta / 2)
      
      let region = MKCoordinateRegion(center: center, span: span)
      
      // Set the region of the map.
      mapView.setRegion(region, animated: true)
    }
    else {
      NSLog("App is backgrounded. New location is %@", newLocation)
    }
  }
  
}

