//
//  OrderTableViewController.swift
//  MohammedSuleiman_MyOrder
//
//  Created by Mohammed on 2021-02-09.
// Name: Mohammed Suleiman Mohamed Al-Falahy    ID: 121083174

import UIKit

class OrderTableViewController: UITableViewController {
     var coffeesOrdered = [CoffeeOrder]()
     private let dbHelper = DatabaseHelper.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Orders"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.getAllCoffeesOrdered() //initialize the data
        self.setupLongPressGesture()
        var bgUIImage : UIImage = UIImage(named: "unnamed")!
        let myInsets : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        bgUIImage = bgUIImage.resizableImage(withCapInsets: myInsets)
        self.view.backgroundColor = UIColor.init(patternImage:bgUIImage)
        self.tableView.rowHeight = 120
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.coffeesOrdered.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cast to viewCell so we can access outlets
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
        
        // Configure the cell...
        if(indexPath.row < self.coffeesOrdered.count){
            cell.coffeeType.text = self.coffeesOrdered[indexPath.row].type
            cell.coffeeSize.text = self.coffeesOrdered[indexPath.row].size
            cell.coffeeOrdered.text = "\(self.coffeesOrdered[indexPath.row].numOrdered)"
        }
       

        return cell
    }
    
    func displayCustomAlert(isNewTask: Bool, indexPath: IndexPath?,
                            alertTitle: String, message: String){
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        if(indexPath != nil){ //for update
            alert.addTextField{(textField: UITextField) in
                textField.text = self.coffeesOrdered[indexPath!.row].type
                textField.isEnabled = false
            }
            
            alert.addTextField{(textField: UITextField) in
                textField.text = self.coffeesOrdered[indexPath!.row].size
                textField.isEnabled = false
            }
            
            alert.addTextField{(textField: UITextField) in
                textField.text = "\(self.coffeesOrdered[indexPath!.row].numOrdered)"
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
                //call method to add new row to the tableView
                if let type = alert.textFields?[0].text, let size = alert.textFields?[1].text, let numOrdered = alert.textFields?[2].text{
                    if(indexPath != nil){
                        if(!size.isEmpty && !type.isEmpty && !numOrdered.isEmpty){
                            self.updateCoffeeOrder(indexPath: indexPath!, size: size, type: type, numOrdered: Int(numOrdered)!)
                        }else{
                            self.showError()
                    }
                }
                }
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }

    private func showError(){
        let errorAlert = UIAlertController(title: "Missing Details", message: "Please fill in both the fields", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    //FOR UPDATING A ROW
    func updateCoffeeOrder(indexPath: IndexPath, size: String, type: String, numOrdered: Int){
        //change the values to provided values
        self.coffeesOrdered[indexPath.row].size = size
        self.coffeesOrdered[indexPath.row].type = type
        self.coffeesOrdered[indexPath.row].numOrdered = Int16(numOrdered)
        
        //invoke the update method
        self.dbHelper.updateOrder(updatedOrder: self.coffeesOrdered[indexPath.row])
        self.getAllCoffeesOrdered()
        
        //reload the row (You can also choose to reload the table as well)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    //FOR DELETING A ROW
    func deleteOrderFromList(indexPath: IndexPath){
        self.dbHelper.deleteOrder(id: self.coffeesOrdered[indexPath.row].id!)
        self.getAllCoffeesOrdered()
    }
    
    //GET ALL COFFEE ORDERS FROM DBHELPER
    func getAllCoffeesOrdered(){
        if(self.dbHelper.getAllOrdersFromDb() != nil){
            self.coffeesOrdered = self.dbHelper.getAllOrdersFromDb()!
            self.tableView.reloadData()
        }else{
            print("No data available in Db")
        }
    }
   
    func setupLongPressGesture(){
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        
        longPressGesture.minimumPressDuration = 1.0 //minimum press is 1 second
        
        //adding gesture to the tableview below
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        //only if the gestures state has ended perform the action below
        if gestureRecognizer.state == .ended {
            //touchpoint gives you the pixels location on where the gesture took place
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            
            //we use the touchpoint to find the indexPath
            let indexPath = self.tableView.indexPathForRow(at: touchPoint)
            
            self.displayCustomAlert(isNewTask: false, indexPath: indexPath, alertTitle: "Edit existing Order", message: "Please provide updated details")
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //delete if within the range
        //ask for confirmation first
        if(indexPath.row < self.coffeesOrdered.count){
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to remove this order?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: {_ in
                self.deleteOrderFromList(indexPath: indexPath)
            }))
            alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
