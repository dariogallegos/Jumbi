//
//  ViewController.swift
//  Jumbi
//
//  Created by dario on 28/05/2019.
//  Copyright © 2019 dario. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var address = ""
    var searchBarController = UISearchController()
    var annotationTapped: MKAnnotation?
    
    @IBOutlet weak var mapView: MKMapView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(action(gestureRecognizer:)))
        //let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(action(gestureRecognizer:)))
        mapView.addGestureRecognizer(tapGesture)
        
        
        let coord1 = CLLocationCoordinate2D(latitude: 40.4173, longitude: -3.706253)
        let poi1 = PointOfInterest(title: "Basurero Green", subtitle:"Verde", coordinate:coord1)
        let coord2 = CLLocationCoordinate2D(latitude: 40.4190, longitude: -3.701818)
        let poi2 = PointOfInterest(title: "Basurero Blue", subtitle:"Azul", coordinate:coord2)
        let coord3 = CLLocationCoordinate2D(latitude: 40.4131, longitude: -3.700808)
        let poi3 = PointOfInterest(title: "Basurero Yellow", subtitle:"Amarillo", coordinate:coord3)
        let coord4 = CLLocationCoordinate2D(latitude: 40.4216, longitude: -3.702828)
        let poi4 = PointOfInterest(title: "Basurero Yellow", subtitle:"Amarillo", coordinate:coord4)
        
        
        mapView.addAnnotation(poi1)
        mapView.addAnnotation(poi2)
        mapView.addAnnotation(poi3)
        mapView.addAnnotation(poi4)
        
    }
    
    
    @IBAction func locationButtonPressed() {
        initLocation()
    }
    
    func addChuchelandia() {
        let coord = CLLocationCoordinate2D(latitude: 40.4167, longitude: -3.70325)
        let poi = PointOfInterest(title: "Chuchelandia",
                                  subtitle: "Se te hace el chuche agua",
                                  coordinate: coord)
        
        mapView.addAnnotation(poi)
    }
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 550.0, longitudinalMeters: 550.0)
        mapView.setRegion(region, animated: true)
    }

    
    //Inicia el pedido de permiso
    func initLocation(){
        let permission = CLLocationManager.authorizationStatus()
        
        if permission == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if permission == .denied {
            alertLocation(titleLocation:"Error de localización", messageLocation: "Actualmente tiene denegada la localización del dispositivo.")
        } else if permission == .restricted {
            alertLocation(titleLocation:"Error de localización", messageLocation: "Actualmente tiene restringida la localización del dispositivo.")
        } else {
            
            guard let currentCoordinate = locationManager.location?.coordinate else {
                return
            }
            
            //ne currentLocation pongo madrid y coneso ta deveria estar
            let region = MKCoordinateRegion(center: currentCoordinate, latitudinalMeters: 550 , longitudinalMeters: 550)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func alertLocation(titleLocation: String, messageLocation: String){
        let alert = UIAlertController(title: titleLocation, message: messageLocation, preferredStyle: .alert)
        let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    //Funcion que gestiona el tap del pin. -necesita esta nomenclatura @objc
    @objc func action(gestureRecognizer: UIGestureRecognizer) {
        
        
        
        //control. Si no las mias iniciales no las borro!
        if let my = annotationTapped{
            debugPrint("El titulo del objeto es \(String(describing: my.title)))")
            self.mapView.removeAnnotation(annotationTapped!)
        }
        //self.mapView.removeAnnotations(mapView.annotations)
        
        
        
        
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoords = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        geocoderLocation(newLocation:CLLocation(latitude: newCoords.latitude, longitude: newCoords.longitude))
        let latitud = String(format: "%.4f",newCoords.latitude)
        let longitud = String(format: "%.4f",newCoords.longitude)
        
       
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoords
        annotation.title = address
        annotation.subtitle = "Latitud: \(latitud) Longitud: \(longitud)"
        
        annotationTapped = annotation
        
        mapView.addAnnotation(annotation)
        
        
        
    }
    
    func geocoderLocation(newLocation: CLLocation){
        var direccion = ""
        geocoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
            if error == nil {
                direccion = "No se ha podido encontrar la direccion"
            }
            if let placemarks = placemarks?.last {
                direccion = self.stringFromPlaceMarks(placemark: placemarks)
            }
            
            self.address = direccion
        }
    }
    
    func stringFromPlaceMarks(placemark: CLPlacemark) -> String {
        var direccion = ""
        
        if let via = placemark.thoroughfare {
            direccion += via + " ,"
        }
        if let calle = placemark.subThoroughfare {
            direccion += calle + " "
        }
        if let localidad =	 placemark.locality {
            direccion += " (\(localidad)) "
        }
        return direccion
    }
    
    //Funcion para mostrar la barra en la parte superior de la view
    @IBAction func showSearchBar(){
        searchBarController = UISearchController(searchResultsController: nil)
        searchBarController.hidesNavigationBarDuringPresentation = false
        self.searchBarController.searchBar.delegate = self
        present(searchBarController, animated: true, completion: nil)
    }
    
    //buscar la direccion del usuario que haya puesto
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // Miramos si existen annontataions , es caso de ser asi descartamos la que tenemos , para cuando le demos a buscar no nos pinte dos pins
        
        // MARK : terminar de usar esto
        if mapView.annotations.count > 1 {
            self.mapView.removeAnnotations(mapView.annotations)
        }
        
        geocoder.geocodeAddressString(searchBar.text!) { (placemarks:[CLPlacemark]?, error:Error?) in
            
            if error == nil {
                let placemark = placemarks?.first
                let annotation = MKPointAnnotation()
                annotation.coordinate = (placemark?.location?.coordinate)!
                annotation.title = searchBar.text!
                
                let spam = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: annotation.coordinate, span: spam)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
            } else {
                print("Error")
            }
        }
        
        
    }
    
}

extension MapViewController : MKMapViewDelegate {
    
    //nuestra posicion actual
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
        debugPrint("se ha actualizado el mapView \(userLocation.coordinate)")
        centerMapOnLocation(userLocation.coordinate)
        //addChuchelandia()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        //Devuelve un pin(annotation) personalizado
        //Vamos a poner un Call Out al pin

        let annotationID = "AnnotationID"
        var annotationView: MKAnnotationView?
        if let dequeueAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationID){
            annotationView = dequeueAnnotationView
            annotationView?.annotation = annotation
        }
        else{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationID)
        }
        
        if let annotation = annotationView?.annotation {
            annotationView?.canShowCallout = true
            
            switch annotation.subtitle {
                case "Verde":
                    annotationView?.image = UIImage(named: "img_verde")
                case "Azul":
                    annotationView?.image = UIImage(named: "img_azul")
                case "Amarillo":
                    annotationView?.image = UIImage(named: "img_amarillo")
                default:
                    annotationView?.image = UIImage(named: "img_pin")
            }
        }
        return annotationView
    }
    


}
