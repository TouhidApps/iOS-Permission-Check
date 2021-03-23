//
//  ViewController.swift
//  Permission Check ViewController
//
//  Created by Touhid on 23/3/21.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBAction func btnGo(_ sender: UIButton) {
        
        // Check camera and media permission before go to this service
        
        let statusCam = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        let statusPhotos = PHPhotoLibrary.authorizationStatus()
        
        if statusCam != .authorized || statusPhotos != .authorized {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PermissionVC") as! PermissionVC
            self.present(vc, animated: true, completion: nil)
        } else {
            labelMessage.text = "All permissions are granted"
        }
        
    } // btnGo
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    
    

}

