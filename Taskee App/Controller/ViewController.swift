//
//  ViewController.swift
//  Taskee App
//
//  Created by Cao Mai on 6/28/20.
//  Copyright © 2020 Make School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var table: UITableView = {
       let newTable = UITableView()
        return newTable
    }()
    
    var sample = ["a", "s", "d", "d", "s"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavBar()
        configureTable()
        
        
    }
    
    private func configureNavBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "All Tasks"
    }
    
    private func configureTable() {
        self.table.frame = self.view.bounds
        self.view.addSubview(self.table)
        self.table.delegate = self
        self.table.dataSource = self
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }


}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sample.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sample[indexPath.row]
        return cell
    }
    
    
}
