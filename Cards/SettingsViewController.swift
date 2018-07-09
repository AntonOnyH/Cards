//
//  SettingsViewController.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/07/08.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
        
    @IBOutlet weak var patternSwitch: UISwitch!
    
    private var shouldShowPattern: Bool {
        return UserDefaults.standard.bool(forKey: "shouldNotShowPattern")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(named: "BackgroundC1")
        configureNavigationBar()
        patternSwitch.setOn(shouldShowPattern, animated: true)
    }
    
    @IBAction func switchDidChangeValue(_ sender: UISwitch) {
        print(sender.isOn)
        UserDefaults.standard.set(sender.isOn, forKey: "shouldNotShowPattern")
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    private func configureNavigationBar() {
        title = NSLocalizedString("Settings", comment: "")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor(named: "SegmentBackgroundColor")
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
