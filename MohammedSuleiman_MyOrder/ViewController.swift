//
//  ViewController.swift
//  MohammedSuleiman_MyOrder
//
//  Created by Mohammed on 2021-02-05.
// Name: Mohammed Suleiman Mohamed Al-Falahy    ID: 121083174

import UIKit

class ViewController: UIViewController {

    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var segmentCoffesize : UISegmentedControl!
    @IBOutlet var numberOfCoffee : UITextField!
    var coffee = Coffee()
    
    //empty array of coffees ordered when app first starts
    var coffeesOrdered = [Coffee]()
    
    let coffeeTypes = ["Dark Roast", "Double Double", "French Vanilla", "Original Blend", "Half and Half"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        let bttnOrders = UIBarButtonItem(title: "Orders", style: .plain, target: self, action: #selector(viewOrders))
        self.navigationItem.setRightBarButton(bttnOrders, animated: true)
        
        var bgUIImage : UIImage = UIImage(named: "unnamed")!
        let myInsets : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         bgUIImage = bgUIImage.resizableImage(withCapInsets: myInsets)
         self.view.backgroundColor = UIColor.init(patternImage:bgUIImage)
    }

    @IBAction func addOrder(){
        //check if number of coffee is provided
        if(self.numberOfCoffee.text!.isEmpty){
            self.showAlert(Errormessage: "You forgot to add how many coffees you want")
        }else{
            self.coffee.type = self.coffeeTypes[self.pickerView.selectedRow(inComponent: 0)]
            self.coffee.size = self.segmentCoffesize.titleForSegment(at: self.segmentCoffesize.selectedSegmentIndex)!
            self.coffee.numOrdered = Int(self.numberOfCoffee.text!)!
            coffeesOrdered.append(self.coffee) //add the coffee object to the array
            
            //call confirm
            self.showConfirm()
        }
    }
    
    @objc
    func viewOrders(){
        if(self.coffeesOrdered.count == 0){
            self.showAlert(Errormessage: "No orders available for display. Add an order to continue.")
        }
        //sends user to different screen to view all his/her orders
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //make instance as! OrdersViewController to allow sending data over
        let ordersVc = storyboard.instantiateViewController(withIdentifier: "ordersVC") as! OrderTableViewController
        ordersVc.coffeesOrdered = self.coffeesOrdered
        self.navigationController?.pushViewController(ordersVc, animated: true)
    }
    
    func showAlert(Errormessage: String){
        let alert = UIAlertController(title: "Ooops", message: Errormessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
 }
    
    func showConfirm(){
        let alert = UIAlertController(title: "Confirmation", message: "Your order has been added. View your orders at the top right. Thanks", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            //clear out previous answers
            self.cleanUI()
        }))
        
        self.present(alert, animated: true, completion: nil)
 }
    
    func cleanUI(){
        self.segmentCoffesize.selectedSegmentIndex = 0
        self.pickerView.reloadComponent(0)
        self.numberOfCoffee.text! = ""
    }
}

//Implement the protocols and its 4 methods
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    //pickerview only has one component
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //for the number of rows in the single component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.coffeeTypes.count
    }
    
    //for displaying a row title in the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.coffeeTypes[row]
    }
    
    //invoke when user selects a row from the pickerview
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected \(self.coffeeTypes[row])")
    }
}

