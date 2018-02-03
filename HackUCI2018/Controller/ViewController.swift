//
//  ViewController.swift
//  HackUCI2018
//
//  Created by Andrew Vo on 2/2/18.
//  Copyright © 2018 Team Alabama. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var image : UIImage = UIImage()
    
    //let coreMLModel = Resnet50()
    let coreMlModel = Inceptionv3()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    @IBAction func tapGesturePressed(_ sender: UITapGestureRecognizer) {
        print("screen is pressed")
        takeScreenshot()
//        performSegue(withIdentifier: "test", sender: self)
    }
    
    @IBAction func swipeGestureSwiped(_ sender: UISwipeGestureRecognizer) {
        print("screen was swiped up")
        performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    func takeScreenshot() {
        //var image = sceneView.snapshot()
        image = sceneView.snapshot()
        classifyImage(image: image)
    }
    

    
    func classifyImage(image: UIImage ){
// first attempt 
        let screenScale = UIScreen.main.scale
        //224 for VGG16, 299 for inception3
        guard let img = resize(image: image, newSize: CGSize(width: 299/screenScale, height: 299/screenScale)) else { return }
        let pixelBuffer = pixelBufferFromImage(image: img)

        guard let VGGPrediction = try? coreMlModel.prediction(image: pixelBuffer) else {
            print("ERROR: Failed to predict")
            return
        }

        print(VGGPrediction.classLabel)
        
        
    }
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
