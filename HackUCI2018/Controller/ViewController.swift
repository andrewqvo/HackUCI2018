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
import CoreML
import Firebase

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var image : UIImage = UIImage()
    
    let model = Inceptionv3()
    var foodItem = ""
    var currentFoodNutrition = nutritionDataModel()
    var dailyValues = [String: Double]()
    var dailyPercentages = [String: Int]()
   

    
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
        foodItem = classifyImage(image)
        currentFoodNutrition.processNutrition(food: foodItem)
        setNutritionVariables(nutrition: currentFoodNutrition)
        //self.updateConsumedUserCalories(calories: currentFoodNutrition.ca)
    }
    
    func setNutritionVariables(nutrition: nutritionDataModel) {
        //DO ALL OPERATIONS IN THIS CLOSURE
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.dailyValues = self.currentFoodNutrition.getResults()
            self.dailyPercentages = self.currentFoodNutrition.getResultsPercentages()
            print(self.dailyValues)
            print(self.dailyPercentages)
            self.updateConsumedUserCalories(calories: Int(self.dailyValues["calories"]!))
        })
    }
    
    //work on firebase
    func updateConsumedUserCalories(calories: Int) {
        let usersDB = Database.database().reference().child("Users")
        guard let myUserID = Auth.auth().currentUser?.uid else {return}
        let userNEW = usersDB.child(myUserID).child("ConsumedCalories")
        userNEW.observeSingleEvent(of: .value) { (snapshot) in
            let snapshotValue = snapshot.value as! Int
            let value = snapshotValue + calories
            userNEW.setValue(value)
            self.updateRemainingUserCalories(calories: calories)
        }
    }
    
    func updateRemainingUserCalories(calories: Int) {
        let usersDB = Database.database().reference().child("Users")
        guard let myUserID = Auth.auth().currentUser?.uid else {return}
        let userNEW = usersDB.child(myUserID).child("RemainingCalories")
        userNEW.observeSingleEvent(of: .value) { (snapshot) in
            let snapshotValue = snapshot.value as! Int
            let value = snapshotValue - calories
            userNEW.setValue(value)
        }
    }

    
    func classifyImage(_ image: UIImage) -> String{
        let size = CGSize(width: 299, height: 299)
        
        guard let pixelBufferImage = image.resize(to: size)?.pixelBuffer() else {
            fatalError("ERROR: Converting to pixel buffer failed!")
        }
        
        guard let inceptOutput = try? model.prediction(image: pixelBufferImage) else {
            fatalError("ERROR: Prediction failed")
        }
        
        let classOutput = inceptOutput.classLabel
        print(classOutput)
        return classOutput
        
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
