//
//  HomeViewController.swift
//  SCS hackathon
//
//  Created by JiaChen(: on 29/11/18.
//  Copyright © 2018 SST Inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var searchLocationSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBarUI()
    }
    
    
    // MARK: Search Bar customisation
    // Probably stolen code from Tasks... PROBABLY.
    func searchBarUI() {
        
        // TextField
        let searchBarTextField = searchLocationSearchBar.value(forKey: "searchField") as? UITextField
        
        // Hint Label
        let searchBarHintLabel = searchBarTextField!.value(forKey: "placeholderLabel") as? UILabel
        searchBarHintLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        
        // Search bar icon
        let searchBarIcon = searchBarTextField?.leftView as! UIImageView
        searchBarIcon.image = searchBarIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        searchBarIcon.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        
        // Search bar text color
        searchBarTextField?.textColor = .white
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
