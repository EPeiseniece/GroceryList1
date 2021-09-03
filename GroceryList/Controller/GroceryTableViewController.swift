//
//  GroceryTableViewController.swift
//  GroceryList
//
//  Created by elina.peiseniece on 16/08/2021.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController {

//    var groceries = [String]()
    var groceries = [Grocery]()
    var manageObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjectContext = appDelegate.persistentContainer.viewContext
        
        
        loadData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    
    func loadData(){
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        
        do{
            let result = try manageObjectContext?.fetch(request)
            groceries = result!
            tableView.reloadData()
        }catch{
            fatalError("Error in retrieving Grocery Data items")
        }
    }
    
    func saveData(){
        do {
            try manageObjectContext?.save()
        } catch  {
            fatalError("Error in saving Grocery item")

        }
    loadData()
    }
    func deleteAllData(){
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Grocery")
    let request: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    do {
        try manageObjectContext?.execute(request)
        saveData()
    } catch let error {
        print(error.localizedDescription)
    }
    }
    
    
    
    @IBAction func addNewItem(_ sender: Any) {
        let alertController = UIAlertController(title: "Grocery Item", message: "What do you want to add?", preferredStyle: .alert)
       
        alertController.addTextField{ textField in
            print(textField)
            
        }
        
        let addActionButton = UIAlertAction(title: "Add", style: .default) { alertAction in
            
            let textFields = alertController.textFields?.first
            let entity = NSEntityDescription.entity(forEntityName: "Grocery", in: self.manageObjectContext!)
            
            let grocery = NSManagedObject(entity: entity!, insertInto: self.manageObjectContext)
            
            grocery.setValue(textFields?.text, forKey: "item")
            self.saveData()
            self.loadData()
//            self.groceries.append(textFields!.text!)
//            self.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(addActionButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAllItemsButton(_ sender: Any) {
        
   let alertController = UIAlertController(title: "Delete All Grocery Item", message: "Are you sure you want to delete them all?", preferredStyle: .actionSheet)
 let addActionButton = UIAlertAction(title: "Delete", style: .default) { alertAction in
     self.deleteAllData()
     
 }//addAction
 
 let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
 
 alertController.addAction(addActionButton)
 alertController.addAction(cancelButton)
 
 present(alertController, animated: true, completion: nil)
 
    }

    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groceries.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)
       
        let grocery = groceries[indexPath.row]
        cell.textLabel?.text = grocery.value(forKey: "item") as? String
        
        cell.accessoryType = grocery.completed ? .checkmark : .none

        return cell
    }


    // MARK: - Table view delegate
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            manageObjectContext?.delete(groceries[indexPath.row])
        }
        self.saveData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        groceries[indexPath.row].completed = !groceries[indexPath.row].completed
        self.saveData()
    }



}
