//
//  CustomTabBarController.swift
//  MultiShop
//
//  Created by APPLE on 09/03/22.
//

import UIKit

class CustomTabBarController: UITabBarController {

    var menuButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
        // Do any additional setup after loading the view.
    }
    
    
    func setupMiddleButton() {
        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 50
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame

        menuButton.backgroundColor = UIColor(named: "BorderColor2")
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)
//        self.tabBar.addSubview(menuButton)

        menuButton.setImage(UIImage(named: "Cart"), for: .normal)
        menuButton.setTitle("", for: .normal)
        menuButton.alignVertical()
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }

    func hideCenterButton()
    {
        menuButton.isHidden = true;
    }

    func showCenterButton()
    {
        menuButton.isHidden = false;
        self.bringcenterButtonToFront();
    }
    
    private func bringcenterButtonToFront()
    {
        print("bringcenterButtonToFront called...")
        self.view.addSubview(self.menuButton)// bringSubviewToFront(self.menuButton);
    }

    // MARK: - Actions

    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 2
        menuButton.backgroundColor = UIColor(named: "AccentColor")
        menuButton.setImage(UIImage(named: "Cart1"), for: .normal)
        menuButton.setTitle("", for: .normal)
        menuButton.setTitleColor(UIColor(named: "White"), for: .normal)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        menuButton.backgroundColor = UIColor(named: "BorderColor2")
        menuButton.setImage(UIImage(named: "Cart"), for: .normal)
        menuButton.setTitle("", for: .normal)
        menuButton.setTitleColor(UIColor(named: "BorderGray"), for: .normal)
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

