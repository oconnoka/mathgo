//
//  ProfileViewController.swift
//  Math Go
//
//  Created by Kathleen O'Connor on 2/1/22.
//

import UIKit
import SwiftUI

class ProfileViewController: UIViewController {
    @IBOutlet weak var selectAvatar: UIButton!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerBeastieCount: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userName = appDelegate.player.name
        playerName.text = "Welcome, \(userName)"
        
        let numberOfBeasties = appDelegate.player.beasties.count
        playerBeastieCount.text = "Beastie Count: \(numberOfBeasties)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        avatarImageView.image = UIImage.scaleImage(imageName: appDelegate.player.avatar, size: 180)
    }
    
    @IBSegueAction func showAvatarChange(_ coder: NSCoder) -> UIViewController? {
        // It would be nice if this didn't take up the whole screen, but
        // if I present it modally, it doesn't change the avatar on the profile screen
        return AvatarChangeHostingController(coder: coder)
    }
    
    @IBAction func showAlert() {
        let alert = UIAlertController(title: "Start Over",
                                      message: "Are you sure? You will lose all caught Beasties and progress.",
                                      preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) -> Void in
            print("Yes button tapped")
            self.deletePlayer(self.appDelegate)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func deletePlayer(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "playerExists")
        UserDefaults.standard.removeObject(forKey: "player")
        
        // Go back to Map screen, which will present Start Screen
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
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

}
