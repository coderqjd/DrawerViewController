//
//  MenuViewController.swift
//  0929-抽屉效果
//
//  Created by 强进冬 on 2017/9/29.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    fileprivate lazy var tableView : UITableView = UITableView()
    
    fileprivate lazy var dataArray : [Any] = [0, 1, 2, 3, 4, 5]
    
    fileprivate var cell : UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
}

// MARK:- UI界面
extension MenuViewController {
    
    fileprivate func setupUI() {
        // 设置头视图
        let headerView = UIView()
        headerView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
        headerView.backgroundColor = UIColor.lightGray
        view.addSubview(headerView)
        
        setupTableView()
        
        setupDeleteAction()
    }
    
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = CGRect.init(x: 0, y: 150, width: view.frame.width, height: UIScreen.main.bounds.height - 150)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
    }
    
    fileprivate func setupDeleteAction() {
        guard let cell = cell else {
            return
        }
        for view in cell.subviews {
            if view.isKind(of: NSClassFromString("UITableViewCellDeleteConfirmationView")!) {
                for btn in view.subviews {
                    if btn.isKind(of: UIButton.self) {
                        (btn as! UIButton).setImage(UIImage.init(named: "bg"), for: .normal)
                    }
                }
            }
        }
    }
}

fileprivate let cellID = "menu"
extension MenuViewController : UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        cell.textLabel?.text = "第\(dataArray[indexPath.section])组"
        cell.selectionStyle = .none
        cell.backgroundView = UIImageView.init(image: UIImage.init(named: "bg"))
        self.cell = cell
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataArray.remove(at: indexPath.section)
        tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: .left)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    // MARK:- 自定义滑动按钮
    /*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = UIColor.lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = UIColor.orange
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = UIColor.blue
        
        return [share, favorite, more]
    }
 */
    
}
