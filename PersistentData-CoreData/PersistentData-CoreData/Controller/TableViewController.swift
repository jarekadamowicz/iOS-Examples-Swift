//
//  TableViewController.swift
//  PersistentData-CoreData
//
//  Created by Jarek Adamowicz on 07/09/2020.
//  Copyright © 2020 Jarek Adamowicz. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load items from context
        loadItems()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonTapped))
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    @objc func addItemButtonTapped() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default, handler: {
            (action) in
            if let newTitle = textField.text {
                
                let item = Item(context: self.context)
                item.name = textField.text!
                item.isChecked = false
                self.itemArray.append(item)
                let indexPath = IndexPath(row: self.itemArray.count-1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .bottom)
                
                self.saveItems()
            }
        })
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].name
        cell.accessoryType = (itemArray[indexPath.row].isChecked) ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /// updating data in context by setValue:forKey: method of the NSManagedObject
        //itemArray[indexPath.row].setValue("Item done", forKey: "name")
        
        /// updating data in context by simply accessing item in the array
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        saveItems()
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(for: indexPath)
        }
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    func deleteItem(for indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        itemArray.remove(at: indexPath.row)
        context.delete(item)

        saveItems()
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
}
