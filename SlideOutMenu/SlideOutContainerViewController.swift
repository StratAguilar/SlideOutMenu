//
//  SlideOutContainerViewController.swift
//  SlideOutMenu
//
//  Created by Strat Aguilar on 9/22/16.
//  Copyright © 2016 Strat Aguilar. All rights reserved.
//

import UIKit

class SlideOutContainerViewController: UIViewController {
  
  enum SlideOutState{
    case shown
    case hidden
  }
  
  var rootNavigationController: UINavigationController?
  var rootViewController: SlideOutRootViewController?
  var menuViewController: SlideOutMenuViewController?
  var currentSlideOutState: SlideOutState = .hidden
  var gestureOriginX: CGFloat = 0
  let slideOutMenuMaxWidth: CGFloat = 300
  let slideOutMenuOpenMaxX: CGFloat  = -20
  let shadowView = UIView()

  override func viewDidLoad() {
      super.viewDidLoad()
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SlideOutContainerViewController.handlePanGesture(recognizer:)))
    self.view.addGestureRecognizer(panGestureRecognizer)
    
    rootViewController = SlideOutRootViewController.initFromNib()
    
    if let rootViewController = rootViewController{
      rootNavigationController = UINavigationController(rootViewController: rootViewController)
      
      if let rootNavigationController = rootNavigationController{
        rootViewController.delegate = self
        view.addSubview(rootNavigationController.view)
        addChildViewController(rootNavigationController)
        rootNavigationController.didMove(toParentViewController: self)
        
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "SlideMenuButton"), style: .plain, target: self, action: #selector(SlideOutContainerViewController.menuAction))
        
        rootNavigationController.navigationBar.topItem?.leftBarButtonItem = menuBarButton
        rootNavigationController.navigationBar.topItem?.title = "Root"
      }
    }
    menuViewController = SlideOutMenuViewController.initFromNib()

  }
  func menuAction(){
    switch currentSlideOutState{
    case .hidden:
      if let menuViewController = menuViewController{
        addShadowView()
        menuViewController.view.frame = CGRect(x: -slideOutMenuMaxWidth, y: 0, width: slideOutMenuMaxWidth, height: self.view.frame.height)
        view.addSubview(menuViewController.view)
        addChildViewController(menuViewController)
        menuViewController.didMove(toParentViewController: self)
        
        UIView.animate(withDuration: 0.3){
          menuViewController.view.frame = CGRect(x: self.slideOutMenuOpenMaxX, y: 0, width: self.slideOutMenuMaxWidth, height: self.view.frame.height)
        }
      }
      currentSlideOutState = .shown
    case .shown:
      break
    }
  }
  
  func addShadowView(){
    if let rootNavigationController = rootNavigationController{
      shadowView.frame = rootNavigationController.view.frame
      shadowView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
      rootNavigationController.view.addSubview(self.shadowView)
      let tapToRemoveMenu = UITapGestureRecognizer(target: self, action: #selector(SlideOutContainerViewController.removeSlideOutMenu))
      tapToRemoveMenu.numberOfTapsRequired = 1
      shadowView.addGestureRecognizer(tapToRemoveMenu)
      UIView.animate(withDuration: 0.3){
        self.shadowView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
      }
    }
  }
  
  func removeShadowView(){
    shadowView.frame = CGRect.zero
    if let tapGesture = shadowView.gestureRecognizers?.first{
      shadowView.removeGestureRecognizer(tapGesture)
    }
    shadowView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    shadowView.removeFromSuperview()
  }
  
  func removeSlideOutMenu(){
    
    if let menuViewController = menuViewController{
      let xEndValue = -menuViewController.view.frame.width
      let frame = menuViewController.view.frame
      removeShadowView()
      
      UIView.animate(withDuration: 0.2, animations: {
        menuViewController.view.frame = CGRect(x: xEndValue, y: frame.origin.y, width: frame.width, height: frame.height)
        
      }){
        [unowned self] complete in
        
        if xEndValue == -menuViewController.view.frame.width{
          self.removeMenuView()
        }
      }
    }
  }
  
  func removeMenuView(){
    menuViewController?.willMove(toParentViewController: nil)
    menuViewController?.view.removeFromSuperview()
    menuViewController?.removeFromParentViewController()
    currentSlideOutState = .hidden
  }
  
  func handlePanGesture(recognizer: UIPanGestureRecognizer){
    print("currentSlideoutState : \(currentSlideOutState)")
    switch currentSlideOutState{
    case .hidden:
      break
    case .shown:
      switch recognizer.state{
      case .began:
        gestureOriginX = recognizer.location(in: view).x
      case .changed:
        
        if let menuViewController = menuViewController{
          var newXValue = recognizer.location(in: view).x - gestureOriginX
          
          if newXValue < -menuViewController.view.frame.width{
            newXValue = -menuViewController.view.frame.width
          }else if newXValue > slideOutMenuOpenMaxX{
            newXValue = slideOutMenuOpenMaxX
          }
          
          let frame = menuViewController.view.frame
          
          UIView.animate(withDuration: 0.1){
            menuViewController.view.frame = CGRect(x: newXValue, y: frame.origin.y, width: frame.width, height: frame.height)
          }
        }
      case .ended:
        if let menuViewController = menuViewController{
          var xEndValue: CGFloat = slideOutMenuOpenMaxX
          
          if menuViewController.view.frame.origin.x <= -menuViewController.view.frame.width / 2{
            xEndValue = -menuViewController.view.frame.width
            removeShadowView()
          }
          
          let frame = menuViewController.view.frame
          UIView.animate(withDuration: 0.2, animations: {
            menuViewController.view.frame = CGRect(x: xEndValue, y: frame.origin.y, width: frame.width, height: frame.height)
          }){
            [unowned self] complete in
            if xEndValue == -menuViewController.view.frame.width{
              self.removeMenuView()
            }
          }
        }
      default:
        break
      }
    }
  }
  
}

extension SlideOutContainerViewController: SlideOutMenuViewControllerDelegate{
  func closeSlideOutMenu() {
    
  }
}

extension SlideOutContainerViewController: SlideOutRootViewControllerDelegate{
  
}
