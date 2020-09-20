//
//  ViewController.swift
//  AutomobileList
//
//  Created by Alexander Kim on 20.09.2020.
//  Copyright © 2020 Alexander Kim. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UITextFieldDelegate {
    
    var carsArray = [Car]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Cars.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(dataFilePath!)
        loadCars()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        loadCars()
        tableView.reloadData()
        
    }
    
    //MARK: - TableView Datacourse Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return carsArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath)
        
        let car = carsArray[indexPath.row]
        
        cell.textLabel?.text = "\(car.array[0])" == "" ? "Не задано" : "\(car.array[0])"
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToDescription", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        carsArray.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveCars()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! CarTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCar = indexPath
        }
        
    }
    
    //MARK: - Add New Cars
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var manufacturerTextField = UITextField()
        var modelTextField = UITextField()
        var yearTextField = UITextField()
        var typeTextField = UITextField()
        
        let alert = UIAlertController(title: "Новый автомобиль", message: "Введите данные нового автомобиля", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        
        let action = UIAlertAction(title: "Добавить", style: .default) { (action) in
            
            let newCar = Car()
            newCar.array.append(manufacturerTextField.text!)
            newCar.array.append(modelTextField.text!)
            if Int(yearTextField.text!) != nil {
                newCar.array.append(yearTextField.text!)
            } else {
                newCar.array.append("")
            }
            newCar.array.append(typeTextField.text!)
            
            self.carsArray.append(newCar)
            self.saveCars()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Производитель"
            manufacturerTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Модель"
            modelTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Год"
            alertTextField.keyboardType = .numberPad
            yearTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Тип кузова"
            typeTextField = alertTextField
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
    
}

