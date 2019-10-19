//
//  TagsColorsViewController.swift
//  PhotoTagger
//
//  Created by setsu on 2019/09/16.
//  Copyright © 2019 setsu. All rights reserved.
//

import UIKit

class TagsColorsViewController: UIViewController {
    
    // MARK: - Properties
    var tags: [String]?
    var colors: [PhotoColor]?
    var tableViewController: TagsColorsTableViewController?
    
    // MARK: - IBOutlet
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DataTable" {
            tableViewController = segue.destination as? TagsColorsTableViewController
        }
    }
    
    // MARK: - IBactions
    @IBAction func tagsColorsSegmentedControlChanged(_ sender: UISegmentedControl) {
        setupTableData()
    }
    
    // MARK: - Public
    
    /// Tableviewデータを設置するメソッド
    func setupTableData() {
        if segmentedControl.selectedSegmentIndex == 0 {
            setupTagsTableData()
        } else {
            setupColorTableData()
        }
        
        tableViewController?.tableView.reloadData()
    }
    
    // タグーTableViewを設置するメソッド
    func setupTagsTableData() {
        if let tags = tags {
            tableViewController?.data = tags.map { tag in
                TagsColorTableData(label: tag, color: nil)
            }
        } else {
            tableViewController?.data = [TagsColorTableData(label: "No tags were fetched.", color: nil)]
        }
    }
    
    // カラーTableViewを設置するメソッド
    func setupColorTableData() {
        if let colors = colors {
            tableViewController?.data = colors.map { photoColor in
                let color = UIColor(red: CGFloat(photoColor.red) / 255,
                                    green: CGFloat(photoColor.green) / 255,
                                    blue: CGFloat(photoColor.blue) / 255,
                                    alpha: 1.0)
                return TagsColorTableData(label: photoColor.colorName, color: color)
            }
        } else {
            tableViewController?.data = [TagsColorTableData(label: "No colors were fetched.", color: nil)]
        }
    }
}
