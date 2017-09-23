//
//  ViewController.swift
//  OpenCVTest
//
//  Created by Joshua Young on 6/14/17.
//  Copyright © 2017 JBYoung. All rights reserved.
//

import UIKit
import MobileCoreServices

let openCVWrapper = OpenCVWrapper()


class ViewController1: UIViewController, FrameExtractorDelegate {

    var frameExtractor: FrameExtractor!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        openCVWrapper.isThisWorking()
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
        
        // DOUBLE TAP
        //tap.addTarget(self, action: #selector("switchCamera"))
        //view.userInteration = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(switchCamera))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        // let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector?)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchCamera(){
        print("SWITCHED")
        frameExtractor.configureSession()
    }

    func captured (image: UIImage){
        imageView.image = openCVWrapper.processImage(image)
        //imageView.image = image
    }

}


// ------------------------------------------------



class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    let picker = UIImagePickerController()
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var Continue: UIButton!

    
    @IBAction func photoFromLibrary(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    

    @IBAction func shootPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Continue.isEnabled = false
        picker.delegate = self
    }

    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        myImageView.contentMode = .scaleAspectFit //3
        myImageView.image = chosenImage //4
        openCVWrapper.initialize(chosenImage)
        Continue.isEnabled = true
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}



//
//  UploadViewController.swift
//  OpenCVTest
//
//  Created by Joshua Young on 6/15/17.
//  Copyright © 2017 JBYoung. All rights reserved.
//
//
//  ViewController.swift
//  PizzaCam
//
//  Created by Joshua Young on 6/15/17.
//  Copyright © 2017 JBYoung. All rights reserved.
//

/*
 class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 
 
 
 @IBOutlet var myImageView: UIImageView!
 
 let picker = UIImagePickerController()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 // Do any additional setup after loading the view, typically from a nib.
 picker.delegate = self
 }
 
 
 /*@IBAction func photoFromLibrary(_ sender: Any) {
 picker.allowsEditing = false
 picker.sourceType = .photoLibrary
 picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
 present(picker, animated: true, completion: nil)
 }
 
 
 @IBAction func shootPhoto(_ sender: Any) {
 if UIImagePickerController.isSourceTypeAvailable(.camera) {
 
 picker.allowsEditing = false
 picker.sourceType = UIImagePickerControllerSourceType.camera
 picker.cameraCaptureMode = .photo
 picker.modalPresentationStyle = .fullScreen
 present(picker,animated: true,completion: nil)}
 else{
 //noCamera()
 }
 
 }
 
 func noCamera(){
 let alertVC = UIAlertController(
 title: "No Camera",
 message: "Sorry, this device has no camera",
 preferredStyle: .alert)
 let okAction = UIAlertAction(
 title: "OK",
 style:.default,
 handler: nil)
 alertVC.addAction(okAction)
 present(
 alertVC,
 animated: true,
 completion: nil)
 }
 
 
 */
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 func imagePickerController(_ picker: UIImagePickerController,
 didFinishPickingMediaWithInfo info: [String : AnyObject])
 {
 let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
 myImageView.contentMode = .scaleAspectFit //3
 myImageView.image = chosenImage //4
 dismiss(animated:true, completion: nil) //5
 }
 func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
 dismiss(animated: true, completion: nil)
 
 }
 
 
 }*/



