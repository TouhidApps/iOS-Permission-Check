//
//  PermissionVC.swift
//  Permission Check ViewController
//
//  Created by Touhid on 23/3/21.
//

import UIKit
import Photos

class PermissionVC: UIViewController {
    
    @IBOutlet weak var labelPhotoPermissionMessage: UILabel!
    @IBOutlet weak var labelCameraPermissionMessage: UILabel!
    
    private var permissionAllowPhoto: Bool = false
    private var permissionAllowCam: Bool = false
    
    @IBOutlet weak var btnPhotoPermission : UIButton!
    @IBOutlet weak var btnCamPermission   : UIButton!
    @IBOutlet weak var btnCancel          : UIButton!
    

    @IBAction func btnCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPhotoPermission(_ sender: UIButton) {
        
        requestPhotoPermission()
        
    } // btnCameraPermission
    
    @IBAction func btnCameraPermission(_ sender: UIButton) {
        
        camPermissionCheck(onlyStatusCheck: false)
        
    } // btnCameraPermission
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnPhotoPermission.layer.cornerRadius = 8
        btnPhotoPermission.layer.masksToBounds = true
        
        btnCamPermission.layer.cornerRadius = 8
        btnCamPermission.layer.masksToBounds = true
                
        btnCancel.layer.cornerRadius = 8
        btnCancel.layer.masksToBounds = true
        
    } // viewDidLoad
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        permissionAllowPhoto = false
        permissionAllowCam   = false
        
        photoPermissionCheck()
        
        camPermissionCheck()
        
       vcDismiss()
        
    } // viewDidAppear
    
    func vcDismiss() {
        print("\(#function) P \(permissionAllowPhoto)--C \(permissionAllowCam)")
        if permissionAllowPhoto && permissionAllowCam {
            self.dismiss(animated: true, completion: nil)
        }
    } // vcDismiss
    
    func photoPermissionCheck() {
        
        // Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        
//        var mMessage = ""
        
        switch photos {
        
        case .notDetermined: // No user interaction yet about permission
            
//            mMessage = "Not Determined"
            permissionAllowPhoto = false
            
            break
            
        case .restricted: // application is not authorized to access photo
            
//            mMessage = "Restricted - not authorized to access photo"
            permissionAllowPhoto = false
            
            break
            
        case .denied: // user denied to access
            
//            mMessage = "Denied to access photo"
            permissionAllowPhoto = false
            
            break
        
        case .authorized: // User authorized to access
            
//            mMessage = "Authorized to access photo"

            permissionAllowPhoto = true
            
            break
            
        case .limited: // ios 14, limited access authorized
            
//            mMessage = "Limited to access photo"
            
            permissionAllowPhoto = true

            break
        
        default:
            break
        }
        
        DispatchQueue.main.async {
            
            var mMessage = ""
            
            if self.permissionAllowPhoto {
                mMessage = "🖼 Photo Permission Granted ✅"
            } else {
                mMessage = "🖼 Photo Permission Not Granted ❌"
            }
            
            self.labelPhotoPermissionMessage.text = mMessage
            
            self.vcDismiss()
            
        }
        
    } // photoPermissionCheck
    
    func requestPhotoPermission() {
        PHPhotoLibrary.requestAuthorization({status in
            
            if status == .notDetermined {
                self.permissionAllowPhoto = false
            } else if status == .authorized {
                self.permissionAllowPhoto = true
            } else {
                self.permissionAllowPhoto = false
                
                let alert = UIAlertController(title: "Alert", message: "You need to allow permission from settings. Want to go settings?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {_ in
                
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {_ in
                
                    alert.dismiss(animated: true, completion: nil)
                
                }))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            } // else
            
            self.photoPermissionCheck()
                        
        })
        
        
    } // requestPhotoPermission
    
    func camPermission() {
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if granted {
                //access granted
//                DispatchQueue.main.async {
//                    self.dismiss(animated: true, completion: nil)
//                }
                
                print("cam granted")
                
            } else {
                print("cam not granted")
                
            }
            self.camPermissionCheck()

        }
        
    } // camPermission
    
    
    // @Param onlyStatusCheck = true means it will just show message not request a permission or alert for settings
    func camPermissionCheck(onlyStatusCheck: Bool = true) {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch status {
            case .notDetermined:
                self.permissionAllowCam = false
                if !onlyStatusCheck {
                    self.camPermission()
                }
                
                break
                
            case .authorized:
                self.permissionAllowCam = true
                break
                
            case .denied:
                self.permissionAllowCam = false
                if !onlyStatusCheck {
                    // Go to setting with alert, if user denied
                    let alert = UIAlertController(title: "Alert", message: "You need to allow permission from settings. Want to go settings?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {_ in
                    
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {_ in
                    
                        alert.dismiss(animated: true, completion: nil)
                    
                    }))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                break
                
            case .restricted:
                self.permissionAllowCam = false
                break
                
            default:
                self.permissionAllowCam = false
                break
        }
        
        DispatchQueue.main.async {
            if self.permissionAllowCam {
                self.labelCameraPermissionMessage.text = "📷 Camera Permission Granted ✅"
            } else {
                self.labelCameraPermissionMessage.text = "📷 Camera Permission Not Granted ❌"
            }
            
            self.vcDismiss()
            
        }
        
    }
 

}
