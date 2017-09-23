//
//  FrameExtractor.swift
//  OpenCVTest
//
//  Created by Joshua Young on 6/14/17.
//  Copyright © 2017 JBYoung. All rights reserved.
//

import AVFoundation
import UIKit

protocol FrameExtractorDelegate: class {
    func captured(image: UIImage)
}

class FrameExtractor: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate{
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue")
    private var permissionGranted = false
    private var position: AVCaptureDevicePosition = .back
    private let quality = AVCaptureSessionPresetMedium
    private let context = CIContext()
    var videoDeviceInput: AVCaptureDeviceInput!

    
    weak var delegate: FrameExtractorDelegate?
    
    override init(){
        super.init()
        checkPermission()
        sessionQueue.async { [unowned self] in
            self.configureSession()
        }
    }

    // MARK: AVSession configuration
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    private func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        }
    }
    /*func changeCamera{
        let currentVideoDevice = self.videoDeviceInput.device

    }*/
    func configureSession() {
        guard permissionGranted else { return }
        captureSession.sessionPreset = quality
        guard let captureDevice = selectCaptureDevice() else { return }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        guard captureSession.canAddInput(captureDeviceInput) else { return }
        captureSession.addInput(captureDeviceInput)
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
        guard let connection = videoOutput.connection(withMediaType: AVFoundation.AVMediaTypeVideo) else { return }
        guard connection.isVideoOrientationSupported else { return }
        guard connection.isVideoMirroringSupported else { return }
        connection.videoOrientation = .portrait
       // connection.isVideoMirrored = position == .front
        if (position == .front){
        connection.isVideoMirrored = false
        }
        else{
            connection.isVideoMirrored = true
        }
        if (self.captureSession.isRunning)
        {
            self.captureSession.stopRunning()
        }
        self.captureSession.startRunning()


    }

    
    private func selectCaptureDevice() -> AVCaptureDevice? {

        let cameraDevice: AVCaptureDevice
        switch position{
        case .front:
            cameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
            position = .back
        case .back:
            cameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
            position = .front
        default:
            cameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
            position = .back
        }
        return cameraDevice

    }
//            let frontCameraDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        
//        let backCameraDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)

        // let availableCameraDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)

       // var backCameraDevice: AVCaptureDevice?
        //var frontCameraDevice: AVCaptureDevice?
        /*for device in availableCameraDevices as! [AVCaptureDevice] {
            if device.position == .back {
                backCameraDevice = device
            }
            else if device.position == .front {
                frontCameraDevice = device
            }
        }
        return frontCameraDevice*/
        
       /* guard let devices = AVCaptureDeviceDiscoverySession(deviceTypes: [], mediaType: AVMediaTypeVideo, position: .front) else {return nil}
        return devices
        
//        for device in devices.devices
//        {
//            print ("HEllo")
//            print(device.position.rawValue)
//            
//        }
 
        return AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)*/
        
            /*.filter {
            ($0 as AnyObject).hasMediaType(AVMediaTypeVideo) &&
                ($0 as AnyObject).position == position
            }.first as? AVCaptureDevice*/
    
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        guard let uiImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        DispatchQueue.main.async { [unowned self] in
            self.delegate?.captured(image: uiImage)
        }
        
    }
    
    // MARK: Sample buffer to UIImage conversion
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
        
    }
    
    
//    /- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
//    {
//    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
//    CGFloat cols = image.size.width;
//    CGFloat rows = image.size.height;
//    
//    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
//    
//    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
//    cols,                       // Width of bitmap
//    rows,                       // Height of bitmap
//    8,                          // Bits per component
//    cvMat.step[0],              // Bytes per row
//    colorSpace,                 // Colorspace
//    kCGImageAlphaNoneSkipLast |
//    kCGBitmapByteOrderDefault); // Bitmap info flags
//    
//    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
//    CGContextRelease(contextRef);
//    
//    return cvMat;
//    }

}



