//
//  CRUDViewModel.swift
//  SciflareTask
//
//  Created by Chandru on 28/05/24.
//

import Foundation
import CoreData

final class CRUDViewModel: ObservableObject {
    
    let manager = CoreDataManager.instance
    let apiLink = "https://crudcrud.com/api/0f4ee9ebced24e6e8a15ddf9e1ffab6f/employee"
    @Published var employees: [Employee] = []
    
    // MARK: -  Fetch Core Data
    
    func fetchUsers() {
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        do {
            self.employees = try manager.context.fetch(request)
        }catch(let error) {
            print("Error fetching. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Get Employee Data Api Call
    
    func loadData() {
        guard let url = URL(string: apiLink) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = manager.context
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data,
                  error == nil ,
                  let res = response as? HTTPURLResponse,
                  res.statusCode >= 200 && res.statusCode < 300 else {
                print("Error downloading data")
                return
            }
            if let _ = try? decoder.decode([Employee].self, from: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.deleteAll()
                    self?.saveData()
                    print("load data success")
                }
            }else {
                print("No data avilable.")
            }
        }.resume()
    }
    
    // MARK: - Delete Employee Data Api Call
    
    func deleteData(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let empid = employees[index].id
        guard let url = URL(string: "\(apiLink)/\(empid ?? "")") else {
            print("Invalid URL")
            return
        }
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling DELETE")
                print(error!)
                return
            }
            guard data != nil else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.deleteAll()
                self?.loadData()
                print("delete data success")
            }
        }.resume()
    }
    
    // MARK: - ADD Employee Data Api Call
    
    func addData(name:String, email: String, mobile: String, gender: String) {
        guard let url = URL(string: apiLink) else {
            print("Invalid URL")
            return
        }
        let empModel = EmpModel(name: name,
                                         email: email,
                                         gender: gender,
                                         mobile: mobile)
        guard let jsonData = try? JSONEncoder().encode(empModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    return
                }
                guard let printedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    return
                }
                self.loadData()
                print(printedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    // MARK: - Update Employee Data Api Call
    
    func updateData(id:String, name:String, email: String, mobile: String, gender: String) {
        
        guard let url = URL(string: "\(apiLink)/\(id)") else {
            print("Invalid URL")
            return
        }
        
        let empModel = EmpModel(name: name,
                                         email: email,
                                         gender: gender,
                                         mobile: mobile)
        guard let jsonData = try? JSONEncoder().encode(empModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling DELETE")
                print(error!)
                return
            }
            guard data != nil else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.loadData()
                print("delete data success")
            }
        }.resume()
    }
    
    // MARK: - Other Methods
    
    func deleteAll() {
        do {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
            let deleteALL = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            try manager.context.execute(deleteALL)
            saveData()
        } catch {
            print ("There is an error in deleting records")
        }
    }
    
    func saveData() {
        DispatchQueue.main.async {
            self.employees.removeAll()
            self.manager.saveData()
            self.fetchUsers()
        }
    }
}
