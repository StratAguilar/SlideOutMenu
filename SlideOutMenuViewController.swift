//
//  SlideOutMenuViewController.swift
//  SlideOutMenu
//
//  Created by Strat Aguilar on 9/22/16.
//  Copyright © 2016 Strat Aguilar. All rights reserved.
//

import UIKit

protocol SlideOutMenuViewControllerDelegate: class{
  func closeSlideOutMenu()
}

class SlideOutMenuViewController: UIViewController {

    weak var delgate: SlideOutMenuViewControllerDelegate?
    static let viewControllerNibName: String = String(describing: SlideOutMenuViewController.self)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  static func initFromNib() -> SlideOutMenuViewController{
    return SlideOutMenuViewController(nibName: viewControllerNibName, bundle: nil)
  }
    

}
