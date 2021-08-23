//
//  GroceryTableViewController.swift
//  GroceryList
//
//  Created by elina.peiseniece on 16/08/2021.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController {
    #warning("app does not update automatically. If you add and run the application again or make any changes they only appear after the run and not immediately. Code is the same as in lesson")
//    var groceries = [String]()
    var groceries = [Grocery]()
    var manageObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjectContext = appDelegate.persistentContainer.viewContext
        
        
        loadData()
        
        

    }
    
    func loadData(){
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        
        do{
            let result = try manageObjectContext?.fetch(request)
            groceries = result!
            
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
#warning ("the for in loop asks to unwrap the optional but I do not understand what there is to do there")
//    func deleteAllData(entity: String){
//        let fetchRequest: NSFetchRequest<Grocery> = Grocery.fetchRequest()
//        fetchRequest.returnsObjectsAsFaults = false
//
//        do {
//            let results = try manageObjectContext?.execute(fetchRequest)
//            for manageObject in results {
//                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                manageObjectContext?.deletedObjects(managedObjectData)
//            }
//
//        } catch let error as NSError {
//            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
//        }
//    }
    
    
    
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
        
        let alertController = UIAlertController(title: "Delete all", message: "Are you sure you want to delete all items?", preferredStyle: .alert)
        
        let deleteActionButton = UIAlertAction(title: "Delete", style: .default) { alertAction in
            <#code#>
        }
        
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
