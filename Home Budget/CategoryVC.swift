//
//  CategoryVC.swift
//  Home Budget
//
//  Created by Admin on 13.09.17.
//  Copyright © 2017 kravchuk. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {

    var store = DataStore.sharedInstance
    
    var isEnableCell = false
    
    var selectAction: ((Category) -> ())?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        categoryTableView.reloadData()
    }
    
    private func saveData(category: Category){
        self.store.categories.append(category)
        
        NSKeyedArchiver.archiveRootObject(self.store.categories, toFile: filePath)
    }

   
    @IBOutlet weak var categoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        loadData()
        self.title = "Categories"
        let rightButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.moveCreateUpdateCategory))
        self.navigationItem.rightBarButtonItem = rightButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveCreateUpdateCategory(sender: UIBarButtonItem) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.performSegue(withIdentifier: "createCategorySegue", sender: self)
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateCategorySegue" {
            if let destination = segue.destination as? CreateUpdateCategoryVC{
                if let index = sender as? Int{
                    destination.index = index
                }
            }

        }
    }
    

}

//MARK: table view delegate
extension CategoryVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if isEnableCell {
            let selectedCategory = self.store.categories[indexPath.row]
            self.selectAction!(selectedCategory)
            _ = navigationController?.popViewController(animated: true)
        }
    
        
        }
}

//MARK: table view data source
extension CategoryVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCell
        
        cell.cellLabel.text = store.categories[indexPath.row].name
//        cell.isUserInteractionEnabled = isEnableCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.store.categories.remove(at: indexPath.row)
//            NSKeyedArchiver.archiveRootObject(self.store.categories, toFile: filePath)
//            
//            categoryTableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "DELETE"){(action, indexPath) in
            self.store.categories.remove(at: indexPath.row)
            NSKeyedArchiver.archiveRootObject(self.store.categories, toFile: self.filePath)
            self.categoryTableView.reloadData()
        }
        let update = UITableViewRowAction(style: .default, title: "UPDATE"){(action, indexPath) in
            let index = indexPath.row
            self.performSegue(withIdentifier: "updateCategorySegue", sender: index)
            self.categoryTableView.reloadData()
        }
        return[delete,update]
    }

}
























