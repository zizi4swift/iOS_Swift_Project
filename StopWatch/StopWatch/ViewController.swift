//
//  ViewController.swift
//  StopWatch
//
//  Created by setsu on 2019/9/23.
//  Copyright © 2019 setsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variable
    // カウンター
    var counter: Float = 0.0 {
        didSet {
            timeLabel.text = String(format: "%.1f", counter)
        }
    }
    
    // タイマー
    var timer: Timer? = Timer()
    
    // 計測しているかフラグ
    var isPlaying = false

    // MARK: - IBOutlet
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var palyBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    
    // MARK: - IBAction
    @IBAction func playBtnTapped(_ sender: UIButton) {
        palyBtn.isEnabled = false
        stopBtn.isEnabled = true
        // 0.1秒単位で計測を開始する
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target:self,
                                     selector: #selector(upDateTimer),
                                     userInfo: nil, repeats: true)
        isPlaying = true
    }
    
    @IBAction func stopBtnTapped(_ sender: UIButton) {
        palyBtn.isEnabled = true
        stopBtn.isEnabled = false
        if let timerTemp = timer {
            timerTemp.invalidate()
        }
        timer = nil
        isPlaying = false
    }
    
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        // タイマーを切る
        if let timerTemp = timer {
            timerTemp.invalidate()
        }
        timer = nil
        isPlaying = false
        counter = 0
        palyBtn.isEnabled = true
        stopBtn.isEnabled = true
    }
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counter = 0.0
    }

    // MARK: - Internal Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc fileprivate func upDateTimer() {
        counter = counter + 0.1
    }
}

