//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Talha Batuhan Irmalı on 18.01.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    

    var nameArr = [String]()
    var idArr = [UUID]()
    var sourceName = ""
    var sourceId: UUID?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addItem))
        tableView.delegate = self
        tableView.dataSource = self
        getData()

    }
    
    @objc func addItem() {
        sourceName = ""
        performSegue(withIdentifier: "secondVC", sender: nil)
    }
    
    @objc func getData() {
        self.nameArr.removeAll(keepingCapacity: true)
        self.idArr.removeAll(keepingCapacity: true)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alldata")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String {
                    self.nameArr.append(name)
                }
                
                if let id = result.value(forKey: "id") as? UUID {
                    
                    self.idArr.append(id)
                }
                self.tableView.reloadData()
            }
            
        } catch {
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "secondVC" {
            let destinationVC = segue.destination as! ViewController2
            destinationVC.targetName = sourceName
            destinationVC.targetId = sourceId
        }
    }


}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArr[indexPath.row]
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sourceName = nameArr[indexPath.row]
        sourceId = idArr[indexPath.row]
        performSegue(withIdentifier: "secondVC", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alldata")
        
        let idString = idArr[indexPath.row].uuidString
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
                if let _ = result.value(forKey: "id") as? UUID {
                    context.delete(result)
                    nameArr.remove(at: indexPath.row)
                    idArr.remove(at: indexPath.row)
                    self.tableView.reloadData()
                    
                    do {
                        try context.save()
                    } catch {
                        
                    }
                }
            }
        } catch {
            
        }

    }
}
