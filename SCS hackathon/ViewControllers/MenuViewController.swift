//
//  MenuViewController.swift
//  SCS hackathon
//
//  Created by JiaChen(: on 30/11/18.
//  Copyright © 2018 SST Inc. All rights reserved.
//

import UIKit
import Lottie

class MenuViewController: UIViewController {

    @IBOutlet weak var lottieView: LOTAnimationView!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var aboutsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        settingsLabel.alpha = 0
        aboutsLabel.alpha = 0
        lottieView.setAnimation(named: "menu_hamburger")
        lottieView.play(fromProgress: 0.5, toProgress: 0.5, withCompletion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.settingsLabel.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseInOut, animations: {
                self.aboutsLabel.alpha = 1
            }) { (_) in
                
            }
        }
        isMenuOpen = true
    }
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
