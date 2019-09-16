//
//  ViewController.swift
//  PhotoTagger
//
//  Created by setsu on 2019/09/15.
//  Copyright © 2019 setsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - IBAction
    @IBAction func tackPicture(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // カメラを起動する
            picker.sourceType = .camera
        } else {
            // 写真を開く
            picker.sourceType = .photoLibrary
            picker.modalPresentationStyle = .fullScreen
        }
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Properties
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("Info did not have the required UIImage for the Original Image")
            dismiss(animated: true, completion: nil)
            return
        }
        
        imageVIew.image = image
        
        // 写真を撮るボタンを隠す
        takePictureButton.isHidden = true
        
        // プログレスビューを表示する
        progressView.progress = 0.0
        progressView.isHidden = false
        
        // ぐるぐるのアニメションをスタートする
        activityIndicatorView.startAnimating()
        
        // TODO:- 写真をサーバにアップロード処理
        
        // 画面を隠す
        dismiss(animated: true, completion: nil)
    }
}

