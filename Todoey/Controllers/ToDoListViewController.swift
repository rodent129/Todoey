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
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")/
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
    }
    
    //MARK: - TableView DataSource Methods
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = arrayItem[indexPath.row]
        
        item.checked = !item.checked
        saveItems()
        
        tableView.cellForRow(at: indexPath)?.accessoryType = item.checked ? .checkmark : .none
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Action handle methods
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
                newItem.categoryRelationship = self.selectedCategory
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
    
    //MARK: - Data Manipulation Methods
    func saveItems() {
        do {
            try context.save()
        }
        catch {
            print("Error save item array: \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //This query method will result wrong if the category has the same name 
        let categroyPredicate = NSPredicate(format: "categoryRelationship.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categroyPredicate, additionalPredicate])
        }
        else {
            request.predicate = categroyPredicate
        }
        
        do {
            arrayItem = try context.fetch(request)
        }
        catch {
            print("Error loading item array: \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - UI Search Bar delegate methods
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: searchPredicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

