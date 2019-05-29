//
//  ViewController.swift
//  Jumbi
//
//  Created by dario on 28/05/2019.
//  Copyright © 2019 dario. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate {

    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var address = ""
    var searchBarController = UISearchController()
    
    @IBOutlet weak var mapView: MKMapView!
    //@IBOutlet weak var lblLatitud: UILabel!
    //@IBOutlet weak var lblLongitud: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        //Cambiamos el UITapGestureRecognizer por el UIlongPressedRecognizer para que no haya problemas
        // cuando pulsemos para moverlo o ver el callout
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(action(gestureRecognizer:)))
        //let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(action(gestureRecognizer:)))
        mapView.addGestureRecognizer(tapGesture)
        
        
    }
    @IBAction func locationButtonPressed() {
        initLocation()
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
            let region = MKCoordinateRegion(center: currentCoordinate, latitudinalMeters: 500 , longitudinalMeters: 500)
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


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Estoy en la location manager")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    
    //Funcion que gestiona el tap del pin. -necesita esta nomenclatura @objc
    @objc func action(gestureRecognizer: UIGestureRecognizer) {
        
        self.mapView.removeAnnotations(mapView.annotations)
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let newCoords = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        geocoderLocation(newLocation:CLLocation(latitude: newCoords.latitude, longitude: newCoords.longitude))
        let latitud = String(format: "%.4f",newCoords.latitude)
        let longitud = String(format: "%.4f",newCoords.longitude)
        
       
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoords
        annotation.title = address
        annotation.subtitle = "Latitud: \(latitud) Longitud: \(longitud)"
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

extension ViewController : MKMapViewDelegate {
    
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
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "img_pin")
        }
        return annotationView
    }
}
