//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationViewControllerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1))
    var chosenImage: UIImage!
    var resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))//CGRectMake(0, 0, 45, 45))
    let rightAccesoryButton = UIButton(type: .detailDisclosure)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.setRegion(sfRegion, animated: false)
        mapView.delegate = self
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        self.navigationController?.popToViewController(self, animated: true)
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = String(describing: latitude)
        
        mapView.addAnnotation(annotation)
        rightAccesoryButton.addTarget(self, action: #selector(onRightAccesoryButton), for: .touchUpInside)
    }
    
    @objc func onRightAccesoryButton(){
        self.performSegue(withIdentifier: "fullImageSegue", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeRenderImageView.image = chosenImage
        
        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.render(in: (UIGraphicsGetCurrentContext() as! CGContext!))
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
//                MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            annotationView?.rightCalloutAccessoryView = rightAccesoryButton
            annotationView?.image = thumbnail
        }

        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = thumbnail//resizeRenderImageView.image //UIImage(named: "camera")
        return annotationView
    }
    
    @IBAction func onCamera(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alertController = UIAlertController()
            let camera = UIAlertAction(title: "Camera", style: .default){ (action) in
                if action.isEnabled{
                    vc.sourceType = .camera
                    self.present(vc, animated: true, completion: nil)
                }
            }
            let photoLibrary = UIAlertAction(title: "Photo Library", style: .default){ (action) in
                if action.isEnabled{
                    vc.sourceType = .photoLibrary
                    self.present(vc, animated: true, completion: nil)
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(camera)
            alertController.addAction(photoLibrary)
            alertController.addAction(cancel)
            
            self.present(alertController, animated: true)
        }else{
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.chosenImage = originalImage
        
        dismiss(animated: true) {
            self.performSegue(withIdentifier: "tagSegue", sender: self)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationsViewController = segue.destination as? LocationsViewController{
            locationsViewController.delegate = self as LocationViewControllerDelegate
        }
        if let fullImageViewController = segue.destination as? FullImageViewController{
            fullImageViewController.photo = chosenImage
        }
    }
    

}
