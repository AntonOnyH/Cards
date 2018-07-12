//
//  SettingsViewController.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/07/08.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingsViewController: UITableViewController {
        
    @IBOutlet weak var patternSwitch: UISwitch!
    @IBOutlet weak var patternLabel: UILabel!
    @IBOutlet weak var smartAuthSwitch: UISwitch!
    @IBOutlet weak var smartAuthLabel: UILabel!
    private let smartAuthManager = SmartAuthManager()
    
    private var shouldShowPattern: Bool {
        return UserDefaults.standard.bool(forKey: "shouldNotShowPattern")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.BackgroundColor.mid
        configureNavigationBar()
        setupSwitches()
    }
    
    private func setupSwitches() {
        patternSwitch.setOn(shouldShowPattern, animated: true)
        smartAuthSwitch.setOn(smartAuthManager.smartAuthIsActive, animated: true)
    }
    
    @IBAction func switchDidChangeValue(_ sender: UISwitch) {
        print(sender.isOn)
        UserDefaults.standard.set(sender.isOn, forKey: "shouldNotShowPattern")
    }
    
    @IBAction func handleSmartAuthSwitchValueChange(_ sender: UISwitch) {
        smartAuthManager.setShouldUseSmartAuth(sender.isOn)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    private func configureNavigationBar() {
        title = NSLocalizedString("Settings", comment: "")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor.BackgroundColor.extraDark
        navigationController?.navigationBar.isTranslucent = false
        
        let button = UIButton()
        button.tintColor = .gray
        button.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleDismissButtonTapped), for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: button)
        barItem.customView?.widthAnchor.constraint(equalToConstant: 22).isActive = true
        barItem.customView?.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        navigationItem.leftBarButtonItem = barItem
    }
    
    @objc private func handleDismissButtonTapped() {
        navigationController?.dismiss(animated: true)
    }
}
