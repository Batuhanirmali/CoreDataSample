//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Talha Batuhan Irmalı on 18.01.2023.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addItem))
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    @objc func addItem() {
        performSegue(withIdentifier: "secondVC", sender: nil)
    }


}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "CoreData"
        return cell
    }
    
}
