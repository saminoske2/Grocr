//
//  GroceryListTableViewController.swift
//  Grocr
//
//  Created by Quinton Quaye on 12/11/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class GroceryListTableViewController: UITableViewController {

//MARK: Outlets
    @IBOutlet weak var userOnlineButton: UIBarButtonItem!
  
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
// MARK: Constants
    let listToUsers = "ListToUsers"
    let ref = FIRDatabase.database().reference(withPath: "grocery-items")
    
    //points to an online location that stores the list of online users.
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    
   
    
// MARK: Properties
    //var data = GroceryData()
    var items: [GroceryItem] = []
    var user: GrocrUser!
    
    
    
    //MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this listens for changes in the values of the database (added, removed, changed)
        //1 - reviews data
        // queryOrdered(byChild:) allows to arrange children in list by "style"
        ref.queryOrdered(byChild: "completed").observe(.value, with: {snapshot in
            
            //2 new items are an empty array
            var newItems: [GroceryItem] = []
            
            //3 - for every item in snapshot as a child, the groceryItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                let groceryItem = GroceryItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
                
            }
            
            // 5 - the main "items" are now the adjusted "newItems"
            self.items = newItems
            self.tableView.reloadData()
            
        })
        
        tableView.allowsSelectionDuringEditing = false
        userOnlineButton.title = "1"
        user = GrocrUser(uid: "FakeId", userName: "ThisNiggaHungry@Wehungry.food")
        
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = GrocrUser(authData: user)
            
            // for users
            //1 - creates a child reference using the uid
            let currentUserRef = self.usersRef.child(self.user.uid)
            
            //2 - use this reference to save to the current users email / username
            currentUserRef.setValue(self.user.userName)
            
            if self.user.userName == "saminoske2@yahoo.com" {
                self.addButton.isEnabled = true
            } else {
            self.addButton.isEnabled = false
            }
            
            //3 - removes the value at the references location after the connection to firebase closes
            currentUserRef.onDisconnectRemoveValue()
        }
        
        // Updating the online User Count
        
        usersRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.userOnlineButton?.title = snapshot.childrenCount.description
            } else {
                self.userOnlineButton?.title = "0"
            }
        })
        
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
        GroceryItemTableViewCell
        let GI = items[indexPath.row]
        
        cell?.getGroceryItems(groceryItem: GI)
        toggleCellCheckbox(cell!, isCompleted: GI.completed)
        
        // Configure the cell...

        return cell!
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
            tableView.reloadData()
        }
    }
    
    // for the cell checkbox
    func toggleCellCheckbox(_ cell: GroceryItemTableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.groceryItem.textColor = UIColor.black
            cell.groceryItemDetail.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.groceryItem.textColor = UIColor.gray
            cell.groceryItemDetail.textColor = UIColor.gray
        }
    }
    
    
    // utilizes the action for the checkbox
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //1
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        //2
        let groceryItem = items[indexPath.row]
        //3
        let toggledCompletion = !groceryItem.completed
        //4
        toggleCellCheckbox(cell as! GroceryItemTableViewCell, isCompleted: toggledCompletion)
        //5
        groceryItem.ref?.updateChildValues(["completed":  toggledCompletion
            ])
    }
    

   
    
   
    
     //MARK: Add Item
    
    @IBAction func addGroceryItem(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Add Grocery Item", message: "Add an Item", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // 1
                // the first textfield array of the alert
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            //2
                // the groceryItem indexPath.row item properties
            let groceryItem = GroceryItem(item: text, addedByUser: self.user.userName, completed: false)
            
            //3
            let groceryItemRef = self.ref.child(text.lowercased())
            
            //4 - adding the value of the child to the function pull of the groceryItem presets
           
            //i.e ref / root = "grocery-items"
            // (child of grocery-items) = groceryItemRef
            
            // once the save button is pressed, the function of toAnyObject will pull the properties of GroceryItem and set the value in the root's child array.
            groceryItemRef.setValue(groceryItem.toAnyObject())
            
            // adding that indexPathItem properties to the array
            self.items.append(groceryItem)
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
    
        present(alert,animated: true,completion: nil)
 
    }
    
    @IBAction func userOnlineButton(_ sender: Any) {
        performSegue(withIdentifier: "ShowUsersOnline", sender: self)
    }

}
