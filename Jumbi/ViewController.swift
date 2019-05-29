//
//  ViewController.swift
//  Jumbi
//
//  Created by dario on 28/05/2019.
//  Copyright © 2019 dario. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var address = ""
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblLatitud: UILabel!
    @IBOutlet weak var lblLongitud: UILabel!
    
    
    
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
        print("Error en la localizacion")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        let userCoord = newLocation.coordinate
        let latitud = Double(userCoord.latitude)
        let longitud = Double(userCoord.longitude)
        
        let latSt = (latitud < 0) ? "S" : "N"
        let lonSt = (longitud < 0) ? "O" : "E"
        
        lblLatitud.text = "\(latSt) \(latitud)"
        lblLongitud.text = "\(lonSt) \(longitud)"
    }
    
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
        if let localidad = placemark.locality {
            direccion += " (\(localidad)) "
        }
        return direccion
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
