

//
//  DDogInfoController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/9.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import SVProgressHUD

private let ID = "InfoCell"

class DDogInfoController: UICollectionViewController {

    // MARK:- 懒加载名字数组
    private lazy var nameArr : [String] = [String]()
    private lazy var nameENArr : [String] = [String]()
    private lazy var bioArr : [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
       
        guard isTableLive("hero")&&isTableLive("items")&&isTableLive("ability") else {
            SVProgressHUD.setMinimumDismissTimeInterval(2)
            SVProgressHUD.showErrorWithStatus("正在加载数据库,请稍后再来")
            return
        }
        
        getHeroNameArr()
    }

}

extension DDogInfoController {
    func getHeroNameArr() {
        let sql1 = "select bio from hero order by name_en"
        DDogFMDBTool.shareInstance.query_DatasByColumn(sql1, targetString: "bio") {[weak self] (results) in
            if results == nil { return }
            self?.bioArr = results!
        }
        
        let sql2 = "select localized_name from hero order by name_en"
        DDogFMDBTool.shareInstance.query_DatasByColumn(sql2, targetString: "localized_name") { [weak self](results) in
            if results == nil { return }
            self?.nameENArr = results!
        }
        
        let sql = "select name_en from hero order by name_en"
        DDogFMDBTool.shareInstance.query_DatasByColumn(sql, targetString: "name_en") { [weak self](results) in
            if results == nil { return }
            self?.nameArr = results!
            self?.collectionView?.reloadData()
        }
    }
}

extension DDogInfoController {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ID, forIndexPath: indexPath) as! DDogInfoCell
        cell.heroName = nameArr[indexPath.item]

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let heroInfoVC = DDogHeroInfosController()
        let names = (nameENArr[indexPath.row])
        heroInfoVC.heroName = names
        heroInfoVC.bio = bioArr[indexPath.row]
        self.navigationController?.pushViewController(heroInfoVC, animated: true)
    }
}