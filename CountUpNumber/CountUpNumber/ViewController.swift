//
//  ViewController.swift
//  CountUpNumber
//
//  Created by setsu on 2019/10/16.
//  Copyright © 2019 setsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var countingLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CADisplayLinkをせ生成
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .default)
    }
    
    // MARK: - Variable
    var startValue: Double = 0
    
    // MARK: - Constant
    let endValue: Double = 1000
    // 動画時間
    let animationDuration: Double = 1.5
    // 動画開始時刻
    let animationStartDate = Date()

    // MARK: - Internal Methods
    
    // アップデートハンドル
    @objc func handleUpdate() {
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        // 経過時間は動画時間より長い場合
        if elapsedTime > animationDuration {
            self.countingLabel.text = "\(endValue)"
        } else {
            // 経過時間は動画時間より短い場合
            let percentage = elapsedTime / animationDuration
            
            let value = percentage * (endValue - startValue)
            self.countingLabel.text = "\(value)"
        }
    }
}

