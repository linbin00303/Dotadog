//
//  DDogPushViewController.swift
//  DotaDog
//
//  Created by 林彬 on 16/5/14.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogPushViewController: UIViewController {
    
//    private lazy var panDict : [String : Bool] = {
//        let panDict = ["canPan" : true , "cannotPan" : false ]
//        return panDict
//    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
       
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let dic = ["isEnable" : false]
        NSNotificationCenter.defaultCenter().postNotificationName("disablePan", object: nil
            , userInfo: dic)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let dic = ["isEnable" : true]
        NSNotificationCenter.defaultCenter().postNotificationName("disablePan", object: nil
            , userInfo: dic)
    }
   
}
