//
//  GroceryItemTableViewCell.swift
//  Grocr
//
//  Created by Quinton Quaye on 12/11/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit

class GroceryItemTableViewCell: UITableViewCell {

    @IBOutlet weak var groceryItem: UILabel!
    
    @IBOutlet weak var groceryItemDetail: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getGroceryItems(groceryItem: GroceryItem){
        self.groceryItem.text = groceryItem.item
        self.groceryItemDetail.text = groceryItem.addedByUser
    }

}
