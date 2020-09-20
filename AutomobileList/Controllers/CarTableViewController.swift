//
//  CarTableViewController.swift
//  AutomobileList
//
//  Created by Alexander Kim on 20.09.2020.
//  Copyright © 2020 Alexander Kim. All rights reserved.
//

import UIKit

class CarTableViewController: UITableViewController {
    
    var selectedCar = IndexPath()
    var carsArray = [Car]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Cars.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCars()
        loadTitle()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return carsArray[selectedCar.row].array.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParametrsCell", for: indexPath)
        cell.textLabel?.text = carsArray[selectedCar.row].array[indexPath.row] == "" ? "Не задано" : carsArray[selectedCar.row].array[indexPath.row]
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var newValueTextField = UITextField()
        
        let alert = UIAlertController(title: "Изменение значения", message: "Введите новое значение", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        let action = UIAlertAction(title: "Сохранить", style: .default) { (action) in
            
            if ((indexPath.row == 2) && (Int(newValueTextField.text!) != nil)) || (indexPath.row != 2) {
                self.carsArray[self.selectedCar.row].array[indexPath.row] = newValueTextField.text!
            }
            
            self.loadTitle()
            self.saveCars()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Новое значение"
            if indexPath.row == 2 {
                alertTextField.keyboardType = .numberPad
            }
            newValueTextField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulating Methods
    
    func saveCars() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(carsArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCars() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                carsArray = try decoder.decode([Car].self, from: data)
            } catch {
                print("Error of decoding \(error)")
            }
        }
    }
    
    func loadTitle() {
        self.title = carsArray[selectedCar.row].array[0] == "" ? "Не задано" : carsArray[selectedCar.row].array[0]
    }
    
}
