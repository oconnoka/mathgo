//
//  ProfileViewController.swift
//  Math Go
//
//  Created by Kathleen O'Connor on 2/1/22.
//

import UIKit
import SwiftUI

class ProfileViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func deletePlayer(_ sender: Any) {
        // TODO - Ask "Are You Sure?"
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
