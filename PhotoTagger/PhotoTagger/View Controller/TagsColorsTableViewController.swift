//
//  TagsColorsTableViewController.swift
//  PhotoTagger
//
//  Created by setsu on 2019/09/16.
//  Copyright © 2019 setsu. All rights reserved.
//

import UIKit

class TagsColorsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource
extension TagsColorsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
