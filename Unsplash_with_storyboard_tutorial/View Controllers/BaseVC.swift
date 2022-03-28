//
//  BaseVC.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by 홍희수 on 2022/03/28.
//

import UIKit

class BaseVC : UIViewController {
    var vcTitle : String = "" {
        didSet {
            print("UserListVC - vcTitle didSet() 호출됨 / vcTitle : \(vcTitle)")
            self.title = vcTitle
        }
    }
}
