//
//  SideMenuViewController.swift
//  mood_capture
//
//  Created by MacBook on 14/11/24.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var closeDrawer: (() -> Void)?
    var logout: (() -> Void)?

    let menuItems = [
            ("Developer", UIImage(named: "user")),
            ("Logout", UIImage(named: "logout")),
        ]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let (title, image) = menuItems[indexPath.row]
        cell.textLabel?.text = title
        cell.imageView?.image = image
        
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.layer.cornerRadius = 8
        cell.imageView?.clipsToBounds = true
        cell.imageView?.contentMode = .scaleAspectFill
        cell.backgroundColor = UIColor.lightTheme
        cell.layoutMargins = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)

            // Handle menu item selection
            let selectedItem = menuItems[indexPath.row].0
            print("\(selectedItem) selected")
        if(selectedItem == "Developer"){
            self.closeDrawer?()
            self.performSegue(withIdentifier: "Developer", sender: self)

        }else if(selectedItem == "Logout"){
                    self.showLoader()
                    FirebaseAuthManager().signOut(completion: {
                        [weak self] result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    self?.hideLoader()
                                    self?.logout?()
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    self?.hideLoader()
                                    self?.showToast(message: error.localizedDescription)
                                }
                            }
                    })
        }

            // Add navigation logic or delegate callback to close the drawer
        }
    

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

//        tableView.separatorStyle = .none // Remove separators
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.versionLabel.text = "V " + (appVersion ?? "")
//        self.nameLabel.text = "Bhushan Koli"
        
        

    }
    


}
