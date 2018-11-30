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

    var onDismiss: (() -> Void)?
    @IBOutlet weak var lottieView: LOTAnimationView!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var aboutsLabel: UILabel!
    
    @IBOutlet weak var homeIcon: UIImageView!
    @IBOutlet weak var settingsIcon: UIImageView!
    @IBOutlet weak var aboutsIcon: UIImageView!
    @IBOutlet weak var selectionIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        settingsLabel.alpha = 0
        aboutsLabel.alpha = 0
        lottieView.setAnimation(named: "menu_hamburger")
        lottieView.play(fromProgress: 0.5, toProgress: 0.5, withCompletion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.homeIcon.alpha = 1
            self.selectionIcon.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0.15, options: .curveEaseInOut, animations: {
                self.settingsLabel.alpha = 1
                self.settingsIcon.alpha = 1
            }) { (_) in
                UIView.animate(withDuration: 0.2, delay: 0.15, options: .curveEaseInOut, animations: {
                    self.aboutsLabel.alpha = 1
                    self.aboutsIcon.alpha = 1
                }) { (_) in
                    
                }
            }
        }
        
    }
    @IBAction func dismissView(_ sender: Any) {
        onDismiss?()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func dismissHome(_ sender: Any) {
        onDismiss?()
        dismiss(animated: false, completion: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 

}
