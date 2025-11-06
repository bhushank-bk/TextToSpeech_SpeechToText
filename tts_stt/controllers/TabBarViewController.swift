//
//  TabBarViewController.swift
//  mood_capture
//
//  Created by MacBook on 06/11/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    var drawerViewController: SideMenuViewController?

    
    var rightBarItem: UIBarButtonItem = UIBarButtonItem()

    @IBOutlet weak var tabbar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

       rightBarItem = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .plain,
            target: revealViewController(),
            action: #selector(loggout)
        )
        
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        setupDrawer()
        filterViewModify()
    }
    
    func filterViewModify(){
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        tabBar.layer.shadowRadius = 6.0
        tabBar.layer.masksToBounds = false
    }
    func setupDrawer() {
        guard let drawerVC = storyboard?.instantiateViewController(withIdentifier: "Drawer") as? SideMenuViewController else { return }
            drawerViewController = drawerVC

            // Add drawer as a child view controller
//            addChild(drawerVC)
            drawerVC.view.frame = CGRect(x: -250, y: 0, width: 250, height: view.frame.height)
            drawerVC.closeDrawer = { [weak self] in
               self?.closeSideMenu()
           }
        drawerVC.logout = { [weak self] in
            self?.logout()
       }
            view.addSubview(drawerVC.view)
            drawerVC.didMove(toParent: self)
        }
    
    @objc func closeSideMenu() {
            guard let drawer = drawerViewController else { return }

            UIView.animate(withDuration: 0.3) {
                drawer.view.frame.origin.x = -250
            }
        }
    @objc func logout() {
            guard let drawer = drawerViewController else { return }

            UIView.animate(withDuration: 0.3) {
                drawer.view.frame.origin.x = -250
            }
        self.navigationController?.popViewController(animated: false)

        }
    @objc func loggout(){
        guard let drawer = drawerViewController else { return }
               UIView.animate(withDuration: 0.3) {
                   drawer.view.frame.origin.x = drawer.view.frame.origin.x == 0 ? -250 : 0
               }
//        self.performSegue(withIdentifier: "SideMenu", sender: self)

//        self.showLoader()
//        FirebaseAuthManager().signOut(completion: {
//            [weak self] result in
//                switch result {
//                case .success:
//                    DispatchQueue.main.async {
//                        self?.hideLoader()
//                        self?.navigationController?.popViewController(animated: true)
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        self?.hideLoader()
//                        self?.showToast(message: error.localizedDescription)
//                    }
//                }
//        })
    }

    

}
