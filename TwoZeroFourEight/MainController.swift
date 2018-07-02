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
    
    @IBAction func playGameTapped(_ sender: SSRoundedButton) {
        //print(sender.currentTitle)
        let vc : UIViewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "GamePanelView") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func quitGameTapped(_ sender: Any) {
        //print(sender.currentTitle)
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
