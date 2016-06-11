//
//  DDogZhanJiViewController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/19.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit
import MJExtension
import SVProgressHUD
class DDogZhanJiViewController: UIViewController {

    let mineCell = "mineCell"
    
    @IBOutlet weak var myTableView: UITableView!    
    
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var navView: UIView!
    
    // 定义一个模型数组
    var playerArr:[DDogPlayerModel]?  {
        didSet {
            // nil值校验
            guard let _ = playerArr else {
                return
            }
            
            // 当发生值改变的时候,重载myTableView
            myTableView.reloadData()
        }
    }
    
    var playerCacheArr : NSArray?
    
    var cacheArr : [String]?
    
    var isInt = false
    
    var tempID : Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMyTableView()
        
        readUserDefault("myArray")
        readPlayersUserDefault("players")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setUpMyTableView() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.searchText.returnKeyType = UIReturnKeyType.Search//更改键盘的return
        self.searchText.delegate = self
        self.myTableView.frame = self.view.bounds
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.tableFooterView = UIView(frame: CGRectZero)
        
        myTableView.registerNib(UINib(nibName: "DDogPlayerTableViewCell", bundle: nil), forCellReuseIdentifier: mineCell)
    }
    
    @IBAction func ButtonClick(sender: AnyObject) {
        searchText.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   

}

extension DDogZhanJiViewController : UITableViewDelegate,UITableViewDataSource {
 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {

            if cacheArr == nil {
                return 1
            }else {
                return cacheArr!.count + 1 + 1
            }
        }else{
            
            if playerArr == nil {
                 return 0
            }else {
                return playerArr!.count
            }
           
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }else {
            return 84
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0 {
            return 0
        }else{
            return 10
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let ID = "cell"
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                    let cell = UITableViewCell(style: .Default, reuseIdentifier: ID)
                    cell.textLabel!.text = "历史搜索"
                    cell.textLabel!.textColor = mainColor
                return cell
            }else if indexPath.row == cacheArr!.count + 1 {
                   let cell = UITableViewCell(style: .Default, reuseIdentifier: ID)
                    cell.textLabel!.text = "清除历史记录"
                    cell.textLabel!.textColor = mainColor
                    cell.textLabel!.textAlignment = NSTextAlignment.Center
                return cell
            }else{
                   let cell = UITableViewCell(style: .Default, reuseIdentifier: ID)
                    // 倒序
//                    let reversedArray = cacheArr!.sort{$0 > $1}
                    cell.textLabel!.text = cacheArr![indexPath.row - 1]
                return cell
            }
        }else{
            guard let _ = playerArr else{
                return UITableViewCell(style: .Default, reuseIdentifier: ID)
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier(mineCell, forIndexPath: indexPath) as! DDogPlayerTableViewCell
            
            cell.model = playerArr![indexPath.row]
            return cell
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        myTableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row != (cacheArr?.count)! + 1 { return }
        
        //清除所有历史记录
        if indexPath.row == cacheArr!.count + 1 {
            let alertController = UIAlertController(title: "清除历史记录", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
    
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: { [weak self](action:UIAlertAction) -> Void in
                DDogSearchCache.removeAllSearchCache("myArray")
                DDogSearchCache.removeAllSearchCache("players")
                self?.cacheArr = nil
                self?.playerArr = nil
                self?.myTableView.reloadData()
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Gradient)
            SVProgressHUD.show()
            
            if self.playerArr == nil {return}
            let playerID = self.playerArr![indexPath.row].steamid
            let temp = Int64(playerID)!
            let number : NSNumber? = NSNumber(longLong: temp)
            // 发送请求
            getPlayerName(number!)
            
        }
    }
    
}

extension DDogZhanJiViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if searchText.text?.characters.count > 0 {
            DDogSearchCache.saveSearchCache(searchText.text!,key : "myArray")
            // 从偏好设置中读取数据
            readUserDefault("myArray")
        }
        
        if searchText.text == nil {
            return false
        }
        searchText.resignFirstResponder()
        
        SVProgressHUD.show()
        
        getPlayerData()
        
        return true
    }
    
    func readUserDefault(key:String) {
        let userDefaultes = NSUserDefaults.standardUserDefaults()
        //读取数组NSArray类型的数据
        let myArray :[String]? = userDefaultes.arrayForKey(key) as? [String]
        guard let _ = myArray else {
            return
        }
        self.cacheArr = myArray!;
    }
    
    func readPlayersUserDefault(key:String){
        let userDefaultes = NSUserDefaults.standardUserDefaults()
        //读取数组NSArray类型的数据
        let temparr = userDefaultes.arrayForKey(key)
        guard let _ = temparr else {
            return
        }
        let myArray :NSArray? = NSArray(array: temparr!)
        var players = [DDogPlayerModel]()
        for dic in myArray! {
            let playerM = DDogPlayerModel(dic: dic as! [String: AnyObject] )
            players.append(playerM)
        }
        self.playerArr = players
    }
    

}

// MARK:- 网络请求
extension DDogZhanJiViewController {
   
     func getPlayerData(){
        // 发送网络请求
        var parameters :[String : AnyObject] = ["key":"75571F3D1597EA1E8E287E127F7C563F" , "vanityurl" : searchText.text!]
        
        // 判断输入的是不是数字
        if  let _ = Int(searchText.text!) {
            isInt = true
        }else {
            isInt = false
        }
        
        if searchText.text?.characters.count < 17 && !isInt {

            // 通过URL查
            DDogLeftViewHttp.getZhanJiNetDataByUrl(parameters) { [weak self](resultMs , error) -> () in
                if error != nil {
                    SVProgressHUD.showErrorWithStatus("网络错误")
                    return
                }
                
                if resultMs == nil {
                    SVProgressHUD.showErrorWithStatus("未找到玩家")
                    
                    self?.myTableView.reloadData()
                    return
                }else {
                    // 用ID查
                    parameters = ["key":"75571F3D1597EA1E8E287E127F7C563F" , "steamids" : resultMs!]
                    DDogLeftViewHttp.getZhanJiNetDataByID(parameters, tianTiMs: { (resultMs , playerName , error) -> () in
                        if error != nil {
                            SVProgressHUD.showErrorWithStatus("网络错误")
                            return
                        }
                        //获得model,进行 push
                        self?.playerArr = resultMs!
                        
                        SVProgressHUD.dismiss()
                    })
                }
            }
        }else {
            if searchText.text!.characters.count < 17 {
                tempID = Int64(searchText.text!)! + 76561197960265728
            }else{
                tempID = Int64(searchText.text!)!
            }
            
            let stringTemp = String(format: "\(tempID)")
            
            // 直接用ID查
            parameters = ["key":"75571F3D1597EA1E8E287E127F7C563F" , "steamids" : stringTemp]
            DDogLeftViewHttp.getZhanJiNetDataByID(parameters, tianTiMs: { [weak self](resultMs , playerName , error) -> () in
                if error != nil {
                    SVProgressHUD.showErrorWithStatus("网络错误")
                    return
                }
                if resultMs == nil {
                    //没有查到人
                    SVProgressHUD.showErrorWithStatus("未找到玩家")
                    
                    self?.myTableView.reloadData()
                    return
                }
                
                SVProgressHUD.dismiss()
                //获得model,进行 push
                self?.playerArr = resultMs!
            })
        }
    }
    
   
    
    func getPlayerName(accountID:NSNumber){
 
        let stringTemp = String(format: "\(accountID)")
        // 直接用ID查
        let parameters = ["key":"75571F3D1597EA1E8E287E127F7C563F" , "steamids" : stringTemp]
        DDogLeftViewHttp.getPlayerNameByID(parameters) { [weak self](playerName , model , error) in
            if error != nil {
                SVProgressHUD.showErrorWithStatus("网络错误")
                return
            }
            if model == nil {
                SVProgressHUD.showErrorWithStatus("网络出错,请重试")
                return
            }
            // push到下个界面
            let showVC = DDogShowZJViewController()
            showVC.player = model
            
            SVProgressHUD.dismiss()
            self?.navigationController?.pushViewController(showVC, animated: true)
        }
    }
    
}
