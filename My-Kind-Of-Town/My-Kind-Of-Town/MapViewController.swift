//
//  MapViewController.swift
//  My-Kind-Of-Town
//
//  Created by Vidur Subaiah on 2/5/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var labelTitle: UILabel!
    
    
    @IBOutlet weak var labelDescription: UILabel!
    
    
    @IBOutlet weak var informationViewLabel: UIView!
    
    
    @IBOutlet weak var starButton: UIButton!
    
    var starButtonSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        self.mapView.showsCompass = false
        self.mapView.pointOfInterestFilter = .excludingAll
        
        // Attribution: Assignment Instructions
        let placeData = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Data", ofType: "plist")!)
        
        let places: NSArray = placeData!["places"] as! NSArray
        
        self.mapView.register(PlaceMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        for place in places {
            // Attribution: https://stackoverflow.com/questions/26445176/anyobject-is-not-convertible-to-string
            let placeDetails = place as! NSDictionary
            let newPlace = Place()
            newPlace.name = (placeDetails["name"]! as! String)
            newPlace.longDescription = (placeDetails["description"]! as! String)
            newPlace.title = newPlace.name
            newPlace.coordinate = CLLocationCoordinate2D(latitude: placeDetails["lat"] as! Double, longitude: placeDetails["long"] as! Double)
            self.mapView.addAnnotation(newPlace)
        }
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Attribution: Lecture Videos
        let miles: Double = 4 * 1600
        let centerPoint = CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298)
        let viewRegion = MKCoordinateRegion(center: centerPoint, latitudinalMeters: miles, longitudinalMeters: miles)
        self.mapView.setRegion(viewRegion, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func starButtonPress(_ sender: UIButton) {
        // Attribution: https://stackoverflow.com/questions/41773645/swift-toggle-uibutton-title-when-selected
        self.starButtonSelected = !self.starButtonSelected
        let locationName = self.labelTitle.text
        if (self.starButtonSelected){
            self.starButton.isSelected = true
            DataManager.sharedInstance.saveFavorite(locationName!)
        }
        else {
            self.starButton.isSelected = false
            DataManager.sharedInstance.deleteFavorite(locationName!)
        }
    }
    
    @IBAction func favoriteButtonPress(_ sender: UIButton) {
        self.informationViewLabel.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favoritesViewController = storyboard.instantiateViewController(identifier: "favorites") as! FavoritesViewController
        // Attribution: https://stackoverflow.com/questions/39450124/swift-programmatically-navigate-to-another-view-controller-scene
        self.present(favoritesViewController, animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationView = view as? PlaceMarkerView else {
            return
        }
        guard let annotation = annotationView.annotation as? Place else {
            return
        }
        if (DataManager.sharedInstance.favorites.contains(annotation.name!)){
            self.starButtonSelected = true
            self.starButton.isSelected = true
        }
        else {
            self.starButtonSelected = false
            self.starButton.isSelected = false 
        }
        self.labelTitle.text = annotation.name
        self.labelDescription.text = annotation.longDescription
        self.informationViewLabel.isHidden = false
    }
}
