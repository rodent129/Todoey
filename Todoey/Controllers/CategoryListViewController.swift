//
//  CategoryListViewController.swift
//  Todoey
//
//  Created by Wang Lisa on 16/03/2018.
//  Copyright © 2018 Lisa Wang. All rights reserved.
//

import UIKit
import CoreData

class CategoryListViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategoryItems()
    }
    
    //MARK: - tableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellItem", for: indexPath)
        
        let categoryItem = categoryArray[indexPath.row]
        
        cell.textLabel?.text = categoryItem.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
            //It already preloaded the items with this category.
//            if let itemsSet = destinationVC.selectedCategory?.itemRelationship {
//                for item in itemsSet.flatMap({ $0 as? Item}) {
//                    print("item: \(String(describing: item.title))")
//                }
//            }
            
        }
    }
    
    //MARK: - Data Handle methods
    
    //MARK: - action handle methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let textFields = alert.textFields
            if let count = textFields?.count, count > 0 {
                let newCategory = Category(context: self.context)
                newCategory.name = textFields![0].text!
                self.categoryArray.append(newCategory)
                self.saveCategoryItems()
                self.tableView.reloadData()
            }
        }
        
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create a category"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadCategoryItems() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Load category item errors: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveCategoryItems() {
        do {
            try context.save()
        }
        catch {
            print("Save category item errors: \(error)")
        }
    }
}
