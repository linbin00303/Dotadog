//
//  DDogShowVidepViewController.swift
//  DotaDog
//
//  Created by 林彬 on 16/6/6.
//  Copyright © 2016年 linbin. All rights reserved.
//

import UIKit

class DDogShowVidepViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.hidden
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
         self.navigationController?.navigationBarHidden = false
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
