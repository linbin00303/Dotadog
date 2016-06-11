//
//  DDogGRPushViewController.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/3.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogGRPushViewController: UIViewController {

    var text : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        let textLabel = UILabel()
        textLabel.center = CGPointMake(ScreenW * 0.5, ScreenH * 0.5)
        textLabel.bounds = CGRectMake(0, 0, ScreenW - 20, 35)
        textLabel.textAlignment = .Center
        if text == nil {
            textLabel.text = "未扫到任何信息"
        }else {
            textLabel.text = text
        }
        view.addSubview(textLabel)   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
