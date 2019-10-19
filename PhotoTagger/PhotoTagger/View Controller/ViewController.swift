//
//  ViewController.swift
//  PhotoTagger
//
//  Created by setsu on 2019/09/15.
//  Copyright © 2019 setsu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    private var tags: [String]?
    private var colors: [PhotoColor]?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // カメラでない場合ボタンのタイトルを変更する
        guard !UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        takePictureButton.setTitle("Select Photo", for: .normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        imageVIew.image = nil
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowResults",
            let controller = segue.destination as? TagsColorsViewController {
            controller.tags = tags
            controller.colors = colors
        }
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
        
        // 写真をサーバにアップロード処理
        upload(image: image,
               progressCompletion: { [unowned self] percent in
                self.progressView.setProgress(percent, animated: true)
            }, completion: {
                [unowned self] tags, colors in
                self.takePictureButton.isHidden = false
                self.progressView.isHidden = true
                self.activityIndicatorView.stopAnimating()
                
                self.tags = tags
                self.colors = colors
                
                self.performSegue(withIdentifier: "ShowResults", sender: self)
        })
        
        // 画面を隠す
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController {
    
    /// 写真をサーバに投げるメソッド
    /// - Parameter image: 写真
    /// - Parameter progressCompletion: 進捗ハンドラー
    /// - Parameter completion: 完了ハンドラー
    func upload(image: UIImage,
                progressCompletion: @escaping (_ percent: Float) -> Void,
                completion: @escaping (_ tags: [String],
                _ colors: [PhotoColor]) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData,
                                     withName: "image",
                                     fileName: "image.jpg",
                                     mimeType: "image/jpeg")
            
        }, with: ImaggaRouter.content,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress { progress in
                    progressCompletion(Float(progress.fractionCompleted))
                }
                
                upload.validate()
                upload.responseJSON { response in
                    guard response.result.isSuccess else {
                        print("Error while uploading file: \(String(describing: response.result.error))")
                        completion([String()], [PhotoColor]())
                        return
                    }
                    
                    guard let responseJSON = response.result.value as? [String : Any],
                        let uploadedFiles = responseJSON["result"] as? [String : Any],
                        let firstFileID = uploadedFiles["upload_id"] as? String else {
                            print("Invalid information received from service")
                            completion([String](), [PhotoColor]())
                            return
                    }
                    
                    print("Content uploaded with ID: \(firstFileID)")
                    
                    self.downloadTags(uploadID: firstFileID) { tags in
                        self.downloadColors(uploadID: firstFileID) { colors in
                            completion(tags, colors)
                    }
                }
            }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    /// タグー結果をダウンロードするメソッド
    /// - Parameter contentID: コンテンツID
    /// - Parameter completion: 完了ハンドラー
    func downloadTags(uploadID: String, completion: @escaping ([String]) -> Void) {
        Alamofire.request(ImaggaRouter.tags(uploadID)).responseJSON { response in
            guard response.result.isSuccess else {
                    print("Error while fetching tags: \(String(describing: response.result.error))")
                    
                    completion([String]())
                    return
            }
            
            guard let responseJSON = response.result.value as? [String : Any],
                let result = responseJSON["result"] as? [String : Any],
                let tagsAndConfidences = result["tags"] as? [[String : Any]] else {
                    print("Invalid tag information received from the service")
                    completion([String]())
                    return
            }
            
            
            let tags = tagsAndConfidences.compactMap { (dict) -> String? in
                guard let tag = dict["tag"] as? [String : Any],
                    let tagName = tag["en"] as? String else {
                        return nil
                }
                return tagName
            }
            
            completion(tags)
        }
    }
    
    
    /// カラー結果をダウンロードするメソッド
    /// - Parameter contentID: コンテンツID
    /// - Parameter completion: 完了ハンドラー
    func downloadColors(uploadID: String, completion: @escaping ([PhotoColor]) -> Void) {
        Alamofire.request(ImaggaRouter.colors(uploadID)).responseJSON {
            response in
            guard response.result.isSuccess else {
                    print("Error while fetching colors: \(String(describing: response.result.error))")
                    completion([PhotoColor]())
                    return
            }
            
            guard let responseJSON = response.result.value as? [String : Any],
                let result = responseJSON["result"] as? [String : Any],
                let info = result["colors"] as? [String : Any],
                let imageColors = info["image_colors"] as? [[String : Any]] else {
                    print("Invalid color information received from service")
                    completion([PhotoColor]())
                    return
            }
            
            let photoColors = imageColors.compactMap { (dict) -> PhotoColor? in
                guard let r = dict["r"] as? Int,
                let g = dict["g"] as? Int,
                let b = dict["b"] as? Int,
                    let closestPaletteColor = dict["closest_palette_color"] as? String else {
                        return nil
                }
                
                return PhotoColor(red: Int(r), green: Int(g), blue: Int(b), colorName: closestPaletteColor)
            }
            
            completion(photoColors)
        }
    }
}
