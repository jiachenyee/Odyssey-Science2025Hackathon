//
//  HomeViewController.swift
//  SCS hackathon
//
//  Created by JiaChen(: on 29/11/18.
//  Copyright © 2018 SST Inc. All rights reserved.
//

import UIKit
import Lottie

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lottieAnimView: LOTAnimationView!
    @IBOutlet weak var searchLocationSearchBar: UISearchBar!
    @IBOutlet weak var headerView: UIView!
    
    var isMenuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBarUI()
        initialiseLottie()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isMenuOpen {
            lottieAnimView.play(fromProgress: 0.7, toProgress: 1, withCompletion: nil)
            closeMenu()
            isMenuOpen = !isMenuOpen
        }
        print("appeard")
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

    func initialiseLottie() {
        lottieAnimView.setAnimation(named: "menu_hamburger")
        
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        if isMenuOpen {
            lottieAnimView.play(fromProgress: 0.7, toProgress: 1, withCompletion: nil)
            closeMenu()
        } else {
            lottieAnimView.play(fromProgress: 0.2, toProgress: 0.5, withCompletion: nil)
            openMenu()
        }
        isMenuOpen = !isMenuOpen
        
    }
    
    func openMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.headerView.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
            self.headerView.frame.size.height += self.headerView.frame.height
            self.searchLocationSearchBar.alpha = 0
        }) { (_) in
            self.searchLocationSearchBar.isHidden = true
            self.performSegue(withIdentifier: "openMenu", sender: nil)
        }
    }
    
    func closeMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.searchLocationSearchBar.isHidden = false
            self.headerView.backgroundColor = UIColor(red: 208/255, green: 126/255, blue: 92/255, alpha: 1)
            self.headerView.frame.size.height = self.headerView.frame.size.height/2
            self.searchLocationSearchBar.alpha = 1
        }) { (_) in
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exhibits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exhibit", for: indexPath) as! ExhibitsCollectionViewCell
        
        cell.exhibitName.text = exhibits[indexPath.row].exhibitTitle.uppercased()
        cell.exhibitMainImage.layer.cornerRadius = 40
        cell.exhibitMainImage.clipsToBounds = true
        cell.exhibitMainImage.image = exhibits[indexPath.row].exhibitImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "selected", sender: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "openMenu", let destination = segue.destination as? MenuViewController {
            destination.onDismiss = {
                self.lottieAnimView.play(fromProgress: 0.7, toProgress: 1, withCompletion: nil)
                self.closeMenu()
                self.isMenuOpen = !self.isMenuOpen
            }
        }
    }
    

}
