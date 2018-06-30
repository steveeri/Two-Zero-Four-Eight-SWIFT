//
//  MainController.swift
//  TwoZeroFourEight
//
//  Created by Steve Richards on 26/06/2018.
//  Copyright © 2018 Steve Richards. All rights reserved.
//

import UIKit

class MainController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playGameTapped(sender:SSRoundedButton) {
        print(sender.currentTitle)
        let vc = GameViewController ( nibName: "Game.storyboard", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func quitGameTapped(sender: SSRoundedButton) {
        print(sender.currentTitle)
        UIControl().sendAction(#selector(NSURLSessionTask.suspend), to: UIApplication.sharedApplication(), forEvent: nil)
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
