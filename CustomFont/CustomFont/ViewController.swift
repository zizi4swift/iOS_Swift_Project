//
//  ViewController.swift
//  CustomFont
//
//  Created by setsu on 2019/10/22.
//  Copyright © 2019 setsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Constant
    
    //　テスト用データ
    let data = ["aaaaaa",
                "bbbbbb",
                "cccccc，dddddd",
                "eeeeee",
                "ffffff",
                "gggggg",
                "hhhhhh",
                "iiiiii",
                "jjjjjj",
                "kkkkkk"]
    
    // フォント名
    let fontNames = ["MFTongXin_Noncommercial-Regular",
                    "MFJinHei_Noncommercial-Regular",
                    "MFZhiHei_Noncommercial-Regular",
                    "Zapfino",
                    "Gaspar Regular"]
    
    // MARK: - Variable
    var fontRowIndex = 0
    
    // MARK: - IBOutlet
    @IBOutlet weak var fontTableView: UITableView!
    
    // MARK: - IBAction
    @IBAction func changeFontBtnTapped(_ sender: UIButton) {
        
        // フォントを更新して、Tableviewリフレッシュさせる
        fontRowIndex = (fontRowIndex + 1) % 5
        fontTableView.reloadData()
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fontTableView.dataSource = self
        fontTableView.delegate = self
    }

    // MARK: - Internal Methods
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}

// MARK: - UITableview DataSouce
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "FontCell"
        let cell = fontTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let text = data[indexPath.row]
        
        cell.textLabel?.text = text
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: self.fontNames[fontRowIndex], size:16)
        
        return cell
    }
}

// MARK: - UITableview Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}

