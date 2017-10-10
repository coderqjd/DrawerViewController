//
//  DrawerViewController.swift
//  0929-抽屉效果
//
//  Created by 强进冬 on 2017/9/29.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {

    // 单例
    // 如果有自定义构造函数, 想要调用init()就必须重写init(); 自定义构造函数后要注意单例的创建方式
    static let shared = UIApplication.shared.keyWindow?.rootViewController as! DrawerViewController
    
    // MARK:- 属性
    var homeVc : UIViewController
    var menuVc : UIViewController
    fileprivate lazy var coverView : UIView = UIView()
    
    // MARK:- 自定义构造函数
    init(homeVc: UIViewController, menuVc: UIViewController) {
        self.homeVc = homeVc
        self.menuVc = menuVc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK:- UI界面
extension DrawerViewController {
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.cyan
        
        addChildViewController(homeVc)
        addChildViewController(menuVc)
        view.addSubview(menuVc.view)
        view.addSubview(homeVc.view)
        
        menuVc.view.frame = CGRect.init(x: -UIScreen.main.bounds.width * 0.75, y: 0, width: UIScreen.main.bounds.width * 0.75 , height: UIScreen.main.bounds.height)
//        homeVc.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        coverView.backgroundColor = UIColor.init(white: 0.5, alpha: 0.6)
        coverView.frame = homeVc.view.bounds
        coverView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(coverViewClick)))
        coverView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(coverViewPan(pan:))))
        // 添加蒙版
        self.homeVc.view.addSubview(self.coverView)
        self.coverView.isHidden = true
        
        setupHomeView()
    }
    
    fileprivate func setupHomeView() {
        homeVc.view.backgroundColor = UIColor.green
        
        let vc = (homeVc as? UINavigationController)?.childViewControllers.first
        vc?.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "菜单", style: .plain, target: self, action: #selector(leftItemClick))
        
        let edgePan = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(screenEdgePan(pan:)))
        edgePan.edges = .left
        homeVc.view.addGestureRecognizer(edgePan)
    }

}

// MARK:- 事件监听
extension DrawerViewController {
    
    /// item点击
    @objc fileprivate func leftItemClick() {
        DrawerViewController.shared.showMenu()
    }
    
    /// 蒙版tap手势事件
    @objc fileprivate func coverViewClick() {
        hiddenMenu()
    }
    
    /// 蒙版pan事件
    @objc fileprivate func coverViewPan(pan: UIPanGestureRecognizer) {
        let offsetX = pan.translation(in: pan.view).x
        if offsetX > 0 {
            showMenu()
            return
        }
        let menuViewW = self.menuVc.view.frame.width
        let alpha = (menuViewW - abs(offsetX)) / menuViewW
        if pan.state == .changed {
            UIView.animate(withDuration: 0.1) {
                self.homeVc.view.frame.origin.x = (offsetX > -menuViewW ? offsetX : -menuViewW) + menuViewW
                self.menuVc.view.frame.origin.x = self.homeVc.view.frame.origin.x - menuViewW
                self.coverView.alpha = alpha < 0.6 ? alpha : 0.6
            }
            
        } else {
            homeVc.view.frame.origin.x < menuVc.view.frame.width * 0.5 ? hiddenMenu() : showMenu()
        }
    }
    
    /// 屏幕边缘手势
    @objc fileprivate func screenEdgePan(pan: UIScreenEdgePanGestureRecognizer) {
        coverView.isHidden = false
        let offsetX = pan.translation(in: pan.view).x
        if offsetX < 0 {
            hiddenMenu()
            return
        }
        let menuViewW = self.menuVc.view.frame.width
        let alpha = offsetX / menuViewW
        if pan.state == .changed {
            UIView.animate(withDuration: 0.1, animations: {
                self.homeVc.view.frame.origin.x = offsetX < menuViewW ? offsetX : menuViewW
                self.menuVc.view.frame.origin.x = self.homeVc.view.frame.origin.x - menuViewW
                self.coverView.alpha = alpha < 0.6 ? alpha : 0.6
            })
            
        } else {
            homeVc.view.frame.origin.x < menuVc.view.frame.width * 0.5 ? hiddenMenu() : showMenu()
        }
    }
}

// MARK:- 显示和隐藏菜单方法
extension DrawerViewController {
    
    func showMenu() {
        self.coverView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.menuVc.view.frame.origin.x = 0
            self.homeVc.view.frame.origin.x = UIScreen.main.bounds.width * 0.75
            self.coverView.alpha = 0.6
        }
    }
    
    func hiddenMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            self.menuVc.view.frame = CGRect.init(x: -UIScreen.main.bounds.width * 0.75, y: 0, width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height)
            self.homeVc.view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.coverView.isHidden = true
        })
    }
}
