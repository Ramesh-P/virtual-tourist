//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/20/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

/**
 * Credits/Attributions:
 * Map tiles are property of OpenStreetMap Foundation and their contributors.
 *
 * OpenStreetMap Attribution
 * -------------------------
 * OpenStreetMap® is open data, licensed under the Open Data Commons Open Database License (ODbL) by the OpenStreetMap Foundation (OSMF).
 * https://www.openstreetmap.org/copyright
 *
 * CARTO Attribution
 * -----------------
 * https://carto.com/attribution
 *
 * Stamen Attribution
 * ------------------
 * Except otherwise noted, each of these map tile sets are © Stamen Design, under a Creative Commons Attribution (CC BY 3.0) license.
 * http://maps.stamen.com/#terrain/12/37.7706/-122.3782
 *
 * For Toner and Terrain: Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL.
 * Map tiles by <a href="http://stamen.com">Stamen Design</a>, under <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>. Data by <a href="http://openstreetmap.org">OpenStreetMap</a>, under <a href=“http://www.openstreetmap.org/copyright">ODbL</a>.
 *
 * For Watercolor: Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under CC BY SA.
 * Map tiles by <a href="http://stamen.com">Stamen Design</a>, under <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>. Data by <a href="http://openstreetmap.org">OpenStreetMap</a>, under <a href="http://creativecommons.org/licenses/by-sa/3.0">CC BY SA</a>.
 *
 */

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: TravelLocationsMapViewController
class TravelLocationsMapViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let navigationControllerDelegate = AppNavigationControllerDelegate()
    var annotation: Annotation?
    var preset: Preset?
    var pin: Pin?
    
    var canLoadPins: Bool = Bool()
    var canDeletePins: Bool = Bool()
    var isEditingPins: Bool = Bool()
    
    var isDownloadingPhotos: Bool = Bool()
    
    // MARK: Outlets
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var hint: UILabel!
    @IBOutlet weak var pinAction: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func deletePin(_ sender: UIBarButtonItem) {
        
        // Set actions
        isEditingPins = !isEditingPins
        canLoadPins = !isEditingPins
        canDeletePins = false
        
        displayEditStatus()
    }
    
    @IBAction func resetMapSize(_ sender: UIBarButtonItem) {
        
        // Reset and save map zoom to normal level
        resetSpan()
    }
    
    @IBAction func deleteAllPins(_ sender: UIBarButtonItem) {
        
        // Set actions
        canDeletePins = true
        canLoadPins = false
        isEditingPins = false
        
        // Delete all pins from map and data store
        fetchPins()
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        navigationControllerDelegate.setAppTitleImage(self)
        banner.image = UIImage(named: appDelegate.bannerImage)
        setMapTileOverlay()
        addGestureReconizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Initialize
        canLoadPins = true
        canDeletePins = false
        isEditingPins = false
        
        // Layout
        displayEditStatus()
        fetchRegion()
        fetchPins()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Class Functions
    func setMapTileOverlay() {
        
        // Add overlay tiles to map view
        let template = Constants.MapOverlay.cartoLightAll
        let overlay = MKTileOverlay(urlTemplate: template)
        
        overlay.canReplaceMapContent = true
        map.add(overlay, level: .aboveLabels)
        map.delegate = self
    }
    
    func addGestureReconizer() {
        
        // Add tap and hold gesture to map view
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addLocationPin(uponGestureReconizer:)))
        map.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: Class Helpers
    func resetEdit() {
        
        // Reset actions
        canLoadPins = true
        canDeletePins = false
        isEditingPins = false
        
        displayEditStatus()
    }
    
    func displayEditStatus() {
        
        // Set edit mode title and user action message
        if (isEditingPins) {
            pinAction.title = "DONE"
            hint.text = "Tap a Pin to Remove"
        } else {
            pinAction.title = "EDIT"
            hint.text = "Tap and Hold to Drop Pin . Tap Pin to Add Photos"
        }
    }
}

// MARK: TravelLocationsMapViewController+Extension
private extension TravelLocationsMapViewController {
    
    // MARK: Location Pins
    func fetchPins() {
        
        // Fetch location pins from data store
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        do {
            let results = try appDelegate.stack.context.fetch(fetchRequest)
            if let results = results as? [Pin] {
                if (results.count > 0) {
                    if (canLoadPins) {
                        
                        // Add previously stored location pins to the map
                        loadLocationPins(from: results)
                    } else if (canDeletePins) {
                        
                        // Delete all pins from map and data store
                        deleteAllPins(in: results)
                    }
                } else {
                    resetEdit()
                }
            }
        } catch {
            fatalError("Could not fetch pins: \(error)")
        }
    }
    
    func loadLocationPins(from results: [Pin]) {
        
        // Add previously stored location pins to the map
        var annotations = [Annotation]()
        
        for pin in results {
            annotation = Annotation(pin: pin)
            annotations.append(annotation!)
        }
        
        map.addAnnotations(annotations)
    }
    
    @objc func addLocationPin(uponGestureReconizer whereTouched: UILongPressGestureRecognizer) {
        
        // Not allowed to add pins in edit mode
        if (isEditingPins) {
            return
        }
        
        // Add location pin
        let location = whereTouched.location(in: map)
        let coordinate = map.convert(location, toCoordinateFrom: map)
        
        if (whereTouched.state == .began) {
            
            // Place location pin in the map where touched
            annotation = Annotation(locationCoordinate: coordinate)
            map.addAnnotation(annotation!)
        } else if (whereTouched.state == .changed) {
            
            // Continue to move pin to a new location as desired
            annotation?.updateCoordinate(newLocationCoordinate: coordinate)
        } else if (whereTouched.state == .ended) {
            
            // Save location pin to data store
            pin = Pin(latitude: (annotation?.locationCoordinate.latitude)!, longitude: (annotation?.locationCoordinate.longitude)!, context: appDelegate.stack.context)
            appDelegate.stack.saveContext()
            
            // Download pictures for pin location

        }
    }
    
    func deleteAllPins(in results: [Pin]) {
        
        // Delete all pins from map and data store
        for pin in results {
            appDelegate.stack.context.delete(pin)
        }
        
        appDelegate.stack.saveContext()
        map.removeAnnotations(map.annotations)
        
        resetEdit()
    }
    
    // MARK: Map Region
    func fetchRegion() {
        
        // Fetch preset location and zoom level from data store
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Preset")
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try appDelegate.stack.context.fetch(fetchRequest)
            if let results = results as? [Preset] {
                if (results.count > 0) {
                    preset = results[0]
                }
            }
        } catch {
            fatalError("Could not fetch map presets: \(error)")
        }
        
        loadRegion()
    }
    
    func loadRegion() {
        
        if (preset != nil) {
            
            // Load preset map location and zoom level
            let latitude = (preset?.latitude)!
            let longitude = (preset?.longitude)!
            let latitudeDelta = (preset?.latitudeDelta)!
            let longitudeDelta = (preset?.longitudeDelta)!
            
            // Set map region by previous location and zoom level choice
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
            let region = MKCoordinateRegionMake(location, span)
            
            map.setRegion(region, animated: true)
        }
    }
    
    func setSpan() {
        
        // Set span to user selected zoom level
        let latitudeDelta = map.region.span.latitudeDelta
        let longitudeDelta = map.region.span.longitudeDelta
        
        setRegion(latitudeDelta, longitudeDelta)
    }
    
    func resetSpan() {
        
        // Reset span to default zoom level
        let latitudeDelta = appDelegate.latitudeDelta
        let longitudeDelta = appDelegate.longitudeDelta
        
        setRegion(latitudeDelta, longitudeDelta)
    }
    
    func setRegion(_ latitudeDelta: CLLocationDegrees, _ longitudeDelta: CLLocationDegrees) {
        
        // Set map to selected location
        let latitude = map.region.center.latitude
        let longitude = map.region.center.longitude
        
        // Set map region per location and zoom level choice
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        let region = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: true)
        saveRegion(region)
    }
    
    func saveRegion(_ region: MKCoordinateRegion) {
        
        // Save map region to user selected location and zoom level
        if (preset == nil) {
            preset = Preset(latitude: region.center.latitude, latitudeDelta: region.span.latitudeDelta, longitude: region.center.longitude, longitudeDelta: region.span.longitudeDelta, context: appDelegate.stack.context)
        } else {
            preset?.latitude = region.center.latitude
            preset?.latitudeDelta = region.span.latitudeDelta
            preset?.longitude = region.center.longitude
            preset?.longitudeDelta = region.span.longitudeDelta
        }
        
        appDelegate.stack.saveContext()
    }
}

// MARK: TravelLocationsMapViewController+MKMapViewDelegate
extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // Render overlay tiles on the map view
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer()
        }
        
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Add custom pin to the map
        let Identifier = "LocationPin"
        var annotationView: MKAnnotationView?
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: Identifier)
            annotationView?.image = UIImage(named: "Pin")
            annotationView?.canShowCallout = false
            annotationView?.centerOffset = CGPoint(x: 0.0, y: -(annotationView?.image?.size.height)!/2)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // Set and save location and zoom level when map region is changed
        setSpan()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation, animated: false)
        
        // Fetch  selected location pin from data store
        let latitude = view.annotation?.coordinate.latitude
        let longitude = view.annotation?.coordinate.longitude
        let predicate = NSPredicate(format: "latitude = %@ AND longitude = %@", argumentArray: [latitude!, longitude!])
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fetchRequest.predicate = predicate
        
        if let results = try? appDelegate.stack.context.fetch(fetchRequest) {
            for pin in results {
                if (isEditingPins) {
                    
                    // Delete selected location pin from map and data store
                    appDelegate.stack.context.delete(pin as! NSManagedObject)
                    appDelegate.stack.saveContext()
                    map.removeAnnotation(view.annotation!)
                    
                    fetchPins()
                } else if (canLoadPins) {
                    
                }
            }
        }
    }
}

