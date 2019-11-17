//
//  ViewController.swift
//  Facebook Animation Clone
//
//  Created by setsu on 2019/10/1.
//  Copyright © 2019 setsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Variable
    
    // MARK: - Life View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // トップ画面タップ挙動認識処理を追加
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    // タップ挙動ハンドラー
    @objc func handleTap() {
        (0...10).forEach { (_) in
            generateAnimatedViews()
        }
    }
    
    // ランダムでアニメーションビューを生成するメソッド
    fileprivate func generateAnimatedViews() {
        let imageName = drand48() > 0.5 ? "like" : "thumbnail"
        let imageView = UIImageView(image: UIImage(named: imageName))
        let dimension = 20 + drand48() * 10
        imageView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        
        // アニメーション周りを設定する
        animation.path = customPath().cgPath
        animation.duration = 2 + drand48() * 3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        // アニメーション追加する
        imageView.layer.add(animation, forKey: nil)
        
        view.addSubview(imageView)
    }
}

// カスタムパス設定メソッド
func customPath() -> UIBezierPath {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: 200))
    
    let endPoint = CGPoint(x: 400, y: 200)
    
    let randomYShift = 200 + drand48() * 300
    
    let cp1 = CGPoint(x: 100, y: 100 - randomYShift)
    let cp2 = CGPoint(x: 200, y: 300 + randomYShift)
    
    path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
    return path
}

class CurvedView: UIView {
    
    override func draw(_ rect: CGRect) {
        let path = customPath()
        
         // パス周りを設定する
        path.lineWidth = 3
        path.stroke()
    }
}

