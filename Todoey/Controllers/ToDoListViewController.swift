//
//  ViewController.swift
//  Todoey
//
//  Created by Lisa Wang on 3/12/18.
//  Copyright © 2018 Lisa Wang. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    //Init empty item array
    var arrayItem = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

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
                let newItem = Item(title: textFields![0].text!)
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(arrayItem)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encode item array: \(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                arrayItem = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error decode item array: \(error)")
            }
        }
    }
}

