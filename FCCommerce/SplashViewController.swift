//
//  SplashViewController.swift
//  FCCommerce
//
//  Created by joe on 9/1/26.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        lottieAnimationView.play()
    }
}
