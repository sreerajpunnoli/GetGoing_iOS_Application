//
//  CameraViewController.swift
//  GetGoing
//
//  Created by MSc CDA on 2019-02-06.
//  Copyright © 2019 Aman Sreeraj. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet var previewView: UIView!
    
    // Mark: - Properties
    
    var session: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = AVCaptureSession()
        session?.sessionPreset = .photo
        guard let backCamera = AVCaptureDevice.default(for: .video) else { return }
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let cameraError as NSError{
            print(cameraError.localizedDescription)
            error = cameraError
        }
        
        guard let session = session else { return }
        if error == nil && session.canAddInput(input) {
            session.addInput(input)
        }
        
        photoOutput = AVCapturePhotoOutput()
        if let output = photoOutput {
            if session.canAddOutput(output) {
                session.addOutput(output)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer?.connection?.videoOrientation = .portrait
                previewLayer?.videoGravity = .resizeAspectFill
                if let layer = previewLayer {
                    previewView.layer.addSublayer(layer)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session?.startRunning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = previewView.bounds
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session?.stopRunning()
    }
    
    @IBAction func capturePhoto(_ sender: UIButton) {
        if photoOutput?.connection(with: AVMediaType.video) != nil {
            photoOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto",
            let destination = segue.destination as? PhotoViewController {
            destination.photo = photo
        }
    }
    
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error:Error?) {
        
        DispatchQueue.main.async {
            if let photoRepresentation = photo.fileDataRepresentation(){
                self.photo = UIImage(data: photoRepresentation)
                self.performSegue(withIdentifier: "showPhoto", sender: self)
            }
        }
        
        
        
    }
}
