//
//  GroceryUsersOnlineTableViewController.swift
//  Grocr
//
//  Created by Quinton Quaye on 12/11/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class GroceryUsersOnlineTableViewController: UITableViewController {
    @IBOutlet weak var signout: UIBarButtonItem!
    
    //MARK: Constants
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    
    //MARK: Properties
    var currentUsers: [String] = []
    var user: GrocrUser!
    
    //MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            if let user = user{
                self.user = GrocrUser(authData: user)
            } else {
                let userRef = self.usersRef.child(self.user.uid)
                userRef.removeValue()
            }
        }
       
    //1 - listens for new items
        usersRef.observe(.childAdded, with: { snap in
           
            //2 - takes the value from the snapshot and apples it to the array as "email"
            guard let email = snap.value as? String else { return }
            self.currentUsers.append(email)
            
            //3 - makes the index row as 0
            let row = self.currentUsers.count - 1
            
            // 4 - created an instance NSIndexPath using calculated row index
            let indexPath = IndexPath(row: row, section: 0)
            
            //5 - inserts the row using an animation that applies the cell from the top.
            self.tableView.insertRows(at: [indexPath], with: .top)
        })
        
        usersRef.observe(.childRemoved, with:  { snap in
            guard let emailToFind = snap.value as? String else { return }
            for (index, email) in self.currentUsers.enumerated() {
                if email == emailToFind {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.currentUsers.remove(at: index)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    
                }
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
        return currentUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!
        OnlineUsersTableViewCell
        
        let onlinUserEmail = currentUsers[indexPath.row]
        cell.userEmailLabel.text = onlinUserEmail

        return cell
    }
    

    //MARK: Actions
    
    @IBAction func sigout(_ sender: Any) {
        
        do {
            try FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
