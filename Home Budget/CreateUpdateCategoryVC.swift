//
//  CreateUpdateCategoryVC.swift
//  Home Budget
//
//  Created by Admin on 16.09.17.
//  Copyright © 2017 kravchuk. All rights reserved.
//

import UIKit

class CreateUpdateCategoryVC: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextField!
    
    var store = DataStore.sharedInstance
    
    var index: Int?
    
    
    //Save data on file
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("Categories").path
    }
    
    private func loadData(){
        if let fileData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as?
            [Category] {
            self.store.categories = fileData
        }
    }
    
    
    private func saveData(category: Category){
        self.store.categories.append(category)
        NSKeyedArchiver.archiveRootObject(self.store.categories, toFile: filePath)
    }
    
    func saveCategory(sender: UIBarButtonItem) {
        let categoryId = UUID().uuidString
        let categoryName = nameField.text!
        let categoryDesc = descriptionField.text!
        
        let newCategory = Category(id: categoryId, name: categoryName, description: categoryDesc)
        self.saveData(category: newCategory)
        navigationController?.popViewController(animated: true)
    }
    func updateCategory(sender: UIBarButtonItem) {
        
        self.store.categories[index!].name = nameField.text!
        self.store.categories[index!].desc = descriptionField.text!
        NSKeyedArchiver.archiveRootObject(store.categories, toFile: filePath)
        navigationController?.popViewController(animated: true)
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()

        if index != nil{
            nameField.text = self.store.categories[index!].name
            descriptionField.text = self.store.categories[index!].desc
            self.title = "Update"
            let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.updateCategory))
            self.navigationItem.rightBarButtonItem = rightButton
        } else {
            nameField.text = ""
            descriptionField.text = ""

            self.title = "Create"
            let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveCategory))
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
