//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1))
    var chosenImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.setRegion(sfRegion, animated: false)
        
    }
    @IBAction func onCamera(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
//        vc.sourceType = UIImagePickerControllerSourceType.camera
        
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
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.chosenImage = originalImage
        
//        dismiss(animated: true, completion: nil)
        dismiss(animated: true) {
            self.performSegue(withIdentifier: "tagSegue", sender: self)
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
