//
//  RoomList.swift
//  Chat
//
//  Created by Юрий Макаров on 10.08.2018.
//  Copyright © 2018 Юрий Макаров. All rights reserved.
//

import UIKit

class RoomList: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView) , name: NSNotification.Name(rawValue: "update"), object: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Room.AllRoom.count
    }

    @objc func refreshTableView(){
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataSourse.shared.deleteRoom(to: Room.AllRoom[indexPath.row].id)
            Room.AllRoom.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        
        cell.autorName.text = Room.AllRoom[indexPath.row].autorName
        cell.id = Room.AllRoom[indexPath.row].id
        cell.titleLbl.text = Room.AllRoom[indexPath.row].titleRoom
        return cell
    }
    
    
    //MARK: Создание нового чата
    @IBAction func newRoom(_ sender: UIBarButtonItem) {
        
     let alertNewRoom = UIAlertController(title: "Новый чат", message: "Введите название нового чата", preferredStyle: .alert)
    let actionCreate = UIAlertAction(title: "Создать", style: .default) { (action) in
        let titleRoom = alertNewRoom.textFields?[0].text
        guard titleRoom != "" else {return}
        DataSourse.shared.CreateNewRoom(title: titleRoom!)
        self.tableView.reloadData()
        }
    let actionCancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        
    alertNewRoom.addTextField { (textFields) in   //Конфигурим TextField в Alert
            textFields.placeholder = "Название чата"
            textFields.autocapitalizationType = .sentences //Каждая 1-я буква слова заглавная
        }
        alertNewRoom.addAction(actionCreate)
        alertNewRoom.addAction(actionCancel)
        self.present(alertNewRoom, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chat" {
        let destination : ChatVC = segue.destination as! ChatVC
        destination.idRoom = Room.AllRoom[(tableView.indexPathForSelectedRow!.row)].id
        destination.titleChat = Room.AllRoom[(tableView.indexPathForSelectedRow!.row)].titleRoom
        }
    }
    
}
