//
//  ViewController.swift
//  DragSlideView
//
//  Created by Jackal Cooper on 11/4/15.
//  Copyright © 2015 Jackal Cooper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
//MARK: Propertities
    var settings : SettingsView!
    override func viewDidLoad() {
        super.viewDidLoad()
        settings = NSBundle.mainBundle().loadNibNamed("Settings", owner: self, options: nil).last as? SettingsView
        settings.frame = CGRectMake(0, -self.view.frame.size.height + 66, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(settings)
        settings.setup()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

