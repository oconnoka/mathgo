//
//  ProfileViewController.swift
//  Math Go
//
//  Created by Kathleen O'Connor on 2/1/22.
//

import UIKit
import SwiftUI
import DropDown

class ProfileViewController: UIViewController {
    @IBOutlet weak var selectAvatar: UIButton!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerBeastieCount: UILabel!
    @IBOutlet var playerAvatar: UIImageView!
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Image1",
            "Image2",
            "Image3",
            "Image4",
            "Image5"
        ]
        
        let avatars = [
            UIImage(named: "avatar1.png"),
            UIImage(named: "avatar2.png"),
            UIImage(named: "avatar3.png"),
            UIImage(named: "avatar4.png"),
            UIImage(named: "avatar5.png")
        ]
        
        menu.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        menu.customCellConfiguration = { index, title, cell in
            guard let cell =  cell as? MyCell else {
                return
            }
            cell.myImageView.image = avatars[index]
        }
        return menu
    }()

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userName = appDelegate.player.name
        playerName.text = userName
        
        let numberOfBeasties = appDelegate.player.beasties.count
        playerBeastieCount.text = "\(numberOfBeasties)"
        
        menu.anchorView = selectAvatar
        
        menu.selectionAction = { index, title in
            print("index \(index) and \(title)")
        }
        
    }

    @IBAction func showAvatarOption(_ sender:Any){
        menu.show()
    }
     
    @IBAction func showAlert() {
        let alert = UIAlertController(title: "Delete Player", message: "Are you sure?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) -> Void in
            print("Yes button tapped")
            self.deletePlayer(self.appDelegate)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped") }
        alert.addAction(yesAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)

    }

    func deletePlayer(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "playerExists")
        UserDefaults.standard.removeObject(forKey: "player")
        showStartScreen()
    }

    // Copied from MapViewController
    // TODO - code clean-up
    private func showStartScreen() {
        appDelegate.setPlayerExists(value: true)
        appDelegate.player = Player()
        let startVC = UIHostingController(rootView: StartView().environmentObject(appDelegate.player))
        startVC.modalPresentationStyle = .fullScreen
        self.present(startVC, animated: false)
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
