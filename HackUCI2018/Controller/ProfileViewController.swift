//
//  ProfileViewController.swift
//  HackUCI2018
//
//  Created by Andrew Vo on 2/3/18.
//  Copyright © 2018 Team Alabama. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var caloriesConsumedLabel: UILabel!
    @IBOutlet weak var remainingCaloriesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
