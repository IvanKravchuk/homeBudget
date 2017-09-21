//
//  TransactionVC.swift
//  Home Budget
//
//  Created by Admin on 13.09.17.
//  Copyright © 2017 kravchuk. All rights reserved.
//

import UIKit

class TransactionVC: UIViewController  {

    @IBOutlet weak var transactionTableView: UITableView!
    
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBAction func showDiagram(_ sender: Any) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.performSegue(withIdentifier: "diagramSegue", sender: self)
        })
    }
    
    var store = DataStore.sharedInstance
    
//    var balance
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        transactionTableView.reloadData()
    }
    
    func calculateBalance(transactions: [Transaction]) -> Double{
        var balanceValue: Double = 0.0
        for transaction in transactions {
            print(transaction.value)
            balanceValue = balanceValue + transaction.value
        }
        return balanceValue
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        let balance = self.calculateBalance(transactions: store.transactions)
//        print(balance)
        self.balanceLabel.text = "Balance \(balance)"
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        
        let rightButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(self.moveCreateUpdateTransaction))
        self.navigationItem.rightBarButtonItem = rightButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveCreateUpdateTransaction(sender: UIBarButtonItem) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.performSegue(withIdentifier: "createTransactionSegue", sender: self)
        })
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateTransactionSegue" {
            if let destination = segue.destination as? CreateUpdateTransactionVC{
                if let index = sender as? Int{
                    destination.index = index
                }
            }
            
        }
    }
    

}

//MARK: table view delegate
extension TransactionVC : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let createUpdateTransactionVC = storyboard?.instantiateViewController(withIdentifier: "createUpdateTransaction") as! CreateUpdateTransactionVC
//        
//        createUpdateTransactionVC.nameText = store.transactions[indexPath.row].name
//        createUpdateTransactionVC.descriptionText = store.transactions[indexPath.row].name
//        createUpdateTransactionVC.category = store.transactions[indexPath.row].category
//        createUpdateTransactionVC.viewTitle = "Update"
//        
//        navigationController?.pushViewController(createUpdateTransactionVC, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: table view data source
extension TransactionVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "transactionCell") as! TransactionCell
        
        cell.cellLabel.text = store.transactions[indexPath.row].name
//        cell.detailTextLabel?.text = self.store.categories[indexPath.row].Description
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.store.transactions.remove(at: indexPath.row)
//            NSKeyedArchiver.archiveRootObject(self.store.transactions, toFile: filePath)
//            
//            transactionTableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "DELETE"){(action, indexPath) in
            self.store.transactions.remove(at: indexPath.row)
            NSKeyedArchiver.archiveRootObject(self.store.transactions, toFile: self.filePath)
            self.transactionTableView.reloadData()
        }
        let update = UITableViewRowAction(style: .default, title: "UPDATE"){(action, indexPath) in
            let index = indexPath.row
            self.performSegue(withIdentifier: "updateTransactionSegue", sender: index)
            self.transactionTableView.reloadData()
        }
        return[delete,update]
    }


}









