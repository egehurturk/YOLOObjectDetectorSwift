//
//  ViewController.swift
//  HumanDetector
//
//  Created by Ege Hurturk on 8.08.2022.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var previewView: UIView!

    private var videoCapture: VideoCapture? = nil
    private let yoloObjectDetectionController = YOLOObjectDetectionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoCapture = VideoCapture(previewView: self.previewView, captureHandler: { [self] (pixelBuffer: CVPixelBuffer) in
            yoloObjectDetectionController.identifyHumansInImage(pixelBuffer: pixelBuffer)
            
        })
        if !(videoCapture?.setupAVCapture())! {
            showAlert(title: "Error", message: "Device must contain a video device.")
            return
        }
        
        yoloObjectDetectionController.setBufferSize(bufferSize: videoCapture!.bufferSize)
        yoloObjectDetectionController.setRootLayer(rootLayer: videoCapture!.getRootLayer())
        yoloObjectDetectionController.setupLayers()
        
        videoCapture?.startCaptureSession()
    }
    
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(ac, animated: true, completion: nil)
        }
    }


}

