//
//  ViewController.swift
//  Todoey
//
//  Created by Lisa Wang on 3/12/18.
//  Copyright © 2018 Lisa Wang. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var arrayItem = ["Shopping Crazy", "Eating Crazy", "Going Crazy"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellItem", for: indexPath)
        
        cell.textLabel?.text = arrayItem[indexPath.row]
        
        return cell
    }
    
    // TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add a new item", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //To do action
            let textFields = alert.textFields
            if let count = textFields?.count, count > 0 {
                print("Add item: \(String(describing: textFields![0].text))")
                self.arrayItem.append(textFields![0].text ?? "New Item")
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

