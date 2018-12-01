//
//  AlertViewController.swift
//  SCS hackathon
//
//  Created by JiaChen(: on 1/12/18.
//  Copyright © 2018 SST Inc. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var exhibitImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var dismissButton: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var onDismiss: (() -> Void)?
    let descriptions = ["All-new Liquid Retina display — the most advanced LCD in the industry. Even faster Face ID. The smartest, most powerful chip in a smartphone. And a breakthrough camera system with Depth Control. iPhone XR. It’s beautiful any way you look at it.",
                        "MacBook Pro elevates the notebook to a whole new level of performance and portability. Wherever your ideas take you, you’ll get there faster than ever with high‑performance processors and memory, advanced graphics, blazing‑fast storage, and more."]
    let titles = ["Apple\niPhone XR",
                        "Apple\nMacBook Pro"]
    let images = [UIImage(named: "xr img"),
                  UIImage(named: "macbook img")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if launchFromAR {
            mainView.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
            descriptionTextView.textColor = .white
            titleLabel.textColor = .white
        } else {
            mainView.backgroundColor = .white
        }
        dismissButton.layer.cornerRadius = 40
        dismissButton.clipsToBounds = true
        
        mainView.layer.cornerRadius = 20
        mainView.clipsToBounds = true
        
        exhibitImage.layer.cornerRadius = 20
        exhibitImage.clipsToBounds = true
        
        titleLabel.text = titles[minorValue - 1]
        descriptionTextView.text = descriptions[minorValue - 1]
        exhibitImage.image = images[minorValue - 1]
        launchFromAR = false
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        onDismiss?()
        dismiss(animated: true, completion: nil)
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
