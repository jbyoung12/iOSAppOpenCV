//
//  UploadImage.swift
//  OpenCVTest
//
//  Created by Joshua Young on 6/15/17.
//  Copyright © 2017 JBYoung. All rights reserved.
//

import Photos
import UIKit

protocol UIImagePickerControllerDelegate: class {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
}


class UploadImage: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{


    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    @IBAction func Upload(_ sender: Any) {
        allowsEditing = false
        sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    init(){
        //checkPermission()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //private var permissionGranted = false

    weak var delegate: UIImagePickerControllerDelegate?
    
  
    @IBAction func photoFromLibrary(_ sender: UIBarButtonItem) {

        
   /* private func checkPermission():
    {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            // The user has granted permission for camera roll
            permissionGranted = true
            break
        case .notDetermined:
            // The user has not yet granted or denied permission
            requestPermission()
        default:
            permissionGranted = false;
        }
    }
    
    private func requestPermission(){
        PHPhotoLibrary.requestAuthorization(handler: (PHAuthorizationStatus) -> Void)granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        }*/


}
