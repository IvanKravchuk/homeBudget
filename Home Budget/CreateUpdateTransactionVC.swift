//
//  CreateUpdateTransactionVC.swift
//  Home Budget
//
//  Created by Admin on 16.09.17.
//  Copyright © 2017 kravchuk. All rights reserved.
//

import UIKit

class CreateUpdateTransactionVC: UIViewController {
    @IBOutlet weak var typeSwitch: UISwitch!

    @IBOutlet weak var typeLabel: UILabel!
    
    @IBAction func onOffSwitch(_ sender: Any) {
        if typeSwitch.isOn{
            typeLabel.text = "gain"
        }else{
            typeLabel.text = "expense"
        }
    }
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBAction func categoryName(_ sender: Any) {
    }
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var valueField: UITextField!
    
    var nameText : String?
    
    var descriptionText : String?
    
    var category : Category?
    
    var viewTitle: String?
    
    var store = DataStore.sharedInstance
    
    var index: Int?
    
    //Save data on file
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("Transactions").path
    }
    
    private func loadData(){
        if let fileData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as?
            [Transaction] {
            self.store.transactions = fileData
        }
    }
   
    
    private func saveData(transaction: Transaction){
        self.store.transactions.append(transaction)
            NSKeyedArchiver.archiveRootObject(self.store.transactions, toFile: filePath)
    }
    
    func updateTransaction(sender: UIBarButtonItem) {
        
        self.store.transactions[index!].name = nameField.text!
        self.store.transactions[index!].desc = descriptionField.text!
        self.store.transactions[index!].category = category!
        self.store.transactions[index!].value = Double(valueField.text!)!
        NSKeyedArchiver.archiveRootObject(store.categories, toFile: filePath)
        navigationController?.popViewController(animated: true)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if index != nil{
            nameField.text = self.store.transactions[index!].name
            descriptionField.text = self.store.transactions[index!].desc
            categoryLabel.text = self.store.transactions[index!].category.name
            valueField.text = String(self.store.transactions[index!].value)
            category = self.store.transactions[index!].category
            self.title = "Update"
            let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.updateTransaction))
            self.navigationItem.rightBarButtonItem = rightButton
        } else {
            nameField.text = ""
            descriptionField.text = ""
            valueField.text = ""
            
            self.title = "Create"
            let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveTransaction))
            self.navigationItem.rightBarButtonItem = rightButton
        }

    }
    func saveTransaction(sender: UIBarButtonItem) {
        let transactionName = nameField.text!
        let transactionDesc = descriptionField.text!
        let transactionValue = Double(valueField.text!)!
        let transactionType = typeSwitch.isOn
        print(transactionType)
        
        let newTransaction = Transaction(name: transactionName, description: transactionDesc, type: transactionType,value: transactionValue, category: category!)
        self.saveData(transaction: newTransaction)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCategorySegue" {
            if let viewController = segue.destination as? CategoryVC {
                viewController.isEnableCell = true
                viewController.selectAction = { selectedCategory in
                    self.category = selectedCategory
                    self.categoryLabel.text = selectedCategory.name
                
                }
            }
        }

    }
 

}

































