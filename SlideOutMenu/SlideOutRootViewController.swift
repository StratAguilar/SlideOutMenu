//
//  SlideOutRootViewController.swift
//  SlideOutMenu
//
//  Created by Strat Aguilar on 9/22/16.
//  Copyright © 2016 Strat Aguilar. All rights reserved.
//

import UIKit

protocol SlideOutRootViewControllerDelegate: class{
  
}

class SlideOutRootViewController: UIViewController {
  
  weak var delegate: SlideOutRootViewControllerDelegate?
  static let viewControllerNibName: String = String(describing: SlideOutRootViewController.self)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  static func initFromNib()-> SlideOutRootViewController{
    return SlideOutRootViewController(nibName: viewControllerNibName, bundle: nil)
  }
}
