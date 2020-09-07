//
//  TableViewController.swift
//  PersistentData-CoreData
//
//  Created by Jarek Adamowicz on 07/09/2020.
//  Copyright © 2020 Jarek Adamowicz. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load items from plist file
        loadItems()
        // if failed to load then stub with default data
        if itemArray.isEmpty {
            itemArray = [
                Item(name: "Buy new iPhone", isChecked: false),
                Item(name: "Buy new iMac", isChecked: false),
                Item(name: "Buy Apple Watch", isChecked: false),
                Item(name: "Buy my Apps!", isChecked: true)
            ]
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonTapped))
        
    }
    
    @objc func addItemButtonTapped() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default, handler: {
            (action) in
            if let newTitle = textField.text {
                self.itemArray.append(Item(name: newTitle, isChecked: false))
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
        print(itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        saveItems()
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func saveItems() {
        let plistEncoder = PropertyListEncoder()
        do {
            let data = try plistEncoder.encode(itemArray)
            try data.write(to: filePath!)
        } catch {
            print("Error encoding itemArray: \(error)")
        }
    }
    
    func loadItems() {
        let plistDecoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: filePath!)
            itemArray = try plistDecoder.decode([Item].self, from: data)
        } catch {
            print("Error decoding data from file: \(error)")
        }
    }
    
}
