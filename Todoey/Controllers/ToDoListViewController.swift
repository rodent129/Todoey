//
//  ViewController.swift
//  Todoey
//
//  Created by Lisa Wang on 3/12/18.
//  Copyright © 2018 Lisa Wang. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    //Init empty item array
    var arrayItem = [Item]()
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")/
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellItem", for: indexPath)
        
        let item = arrayItem[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.checked ? .checkmark : .none
        
        return cell
    }
    
    // TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = arrayItem[indexPath.row]
        
        item.checked = !item.checked
        
        tableView.cellForRow(at: indexPath)?.accessoryType = item.checked ? .checkmark : .none
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add a new item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //To do action
            let textFields = alert.textFields
            if let count = textFields?.count, count > 0 {
                print("Add item: \(String(describing: textFields![0].text))")
                let newItem = Item(context: self.context)
                newItem.title = textFields![0].text!
                newItem.checked = false
                self.arrayItem.append(newItem)
                self.saveItems()
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        }
        catch {
            print("Error save item array: \(error)")
        }
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            arrayItem = try context.fetch(request)
        }
        catch {
            print("Error loading item array: \(error)")
        }
    }
}

