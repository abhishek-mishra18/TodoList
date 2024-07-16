//
//  ViewController.swift
//  TodoList
//
//  Created by Abhishek on 12/07/24.
//

import UIKit
import Foundation

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models : [TodoListData] = []
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Todo App"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        getAllItems()
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Todo",
                                      message: "Enter New Todo",
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
                textField.placeholder = "First item"
            }
            
            // Add a spacer using a second text field
            let spacerTextField = UITextField()
            spacerTextField.isUserInteractionEnabled = false
            spacerTextField.borderStyle = .none
            spacerTextField.frame = CGRect(x: 0, y: 0, width: alert.view.bounds.size.width, height: 10)
            alert.view.addSubview(spacerTextField)
            
            // Second text field configuration
            alert.addTextField { textField in
                textField.placeholder = "Second item"
            }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let firstField = alert.textFields?[0],
                  let secondField = alert.textFields?[1],
                  let text1 = firstField.text, !text1.isEmpty,
                  let text2 = secondField.text, !text2.isEmpty else {
                return
            }
            self?.createItem(title: text1, description: text2)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.identifier , for: indexPath) as! MyTableViewCell
        cell.title.text = model.todoTitle
        //cell.myDescription.text = model.todoDescription
        
        if let createdAt = model.createdAt {
            cell.createdAt.text = DateFormatter.localizedString(from: createdAt, dateStyle: .short, timeStyle: .none)
                }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true )
        let todo = models[indexPath.row]
        let sheet = UIAlertController(title: "Edit methods",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        
        sheet.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        
        sheet.addAction(UIAlertAction(title: "Edit",
                                      style: .default,
                                      handler: { _ in
            let alert = UIAlertController(title: "Edit Todo",
                                          message: "",
                                          preferredStyle: .alert)
            
            alert.addTextField { textField in
                    textField.placeholder = "First item"
                }
                
                // Add a spacer using a second text field
                let spacerTextField = UITextField()
                spacerTextField.isUserInteractionEnabled = false
                spacerTextField.borderStyle = .none
                spacerTextField.frame = CGRect(x: 0, y: 0, width: alert.view.bounds.size.width, height: 10)
                alert.view.addSubview(spacerTextField)
                
                // Second text field configuration
                alert.addTextField { textField in
                    textField.placeholder = "Second item"
                }
            
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { _ in
                guard let firstField = alert.textFields?[0],
                      let secondField = alert.textFields?[1],
                      let text1 = firstField.text, !text1.isEmpty,
                      let text2 = secondField.text, !text2.isEmpty else {
                    return
                }
                self.updateItem(todo: todo, newTitle: text1, newDescripption: text2)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "Delete",
                                      style: .destructive,
                                      handler: { [weak self] _ in
            self?.deleteItem(todo: todo)
        }))
        present(sheet, animated: true)
    }

    
    
    
    
    
    
    
    
    // core Data code
    private func getAllItems(){
        do{
            models = try context.fetch(TodoListData.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{}
        
    }
    
    private func createItem(title: String,description: String){
        let newItem = TodoListData(context: context)
        newItem.todoTitle = title
        newItem.todoDescription = description
        newItem.createdAt = Date()
        do{
            try context.save()
            getAllItems()
        }
        catch{}
    }
    
    private func deleteItem(todo: TodoListData){
        context.delete(todo)
        do{
            try context.save()
            getAllItems()
        }
        catch{}
    }
    
    private func updateItem(todo: TodoListData,newTitle: String,newDescripption: String){
        todo.todoTitle = newTitle
        todo.todoDescription = newDescripption
        do{
            try context.save()
            getAllItems()
        }
        catch{}
    }
    
}

