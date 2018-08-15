//
//  DataSourse.swift
//  Chat
//
//  Created by Юрий Макаров on 10.08.2018.
//  Copyright © 2018 Юрий Макаров. All rights reserved.
//

import Firebase


final class DataSourse {
    
    static let shared = DataSourse()
    private let ref = Database.database().reference()
    private init() {}
    let myID = Auth.auth().currentUser?.uid
    let MyName = Auth.auth().currentUser?.displayName!
    
    //Выход
    final func LogOut(){
        try! Auth.auth().signOut()
    }
    
    //Загрузка чатов
    final func DownloadRoom(){
        self.ref.child("ChatRoom").observe(.value) { (snapshot) in
            Room.AllRoom.removeAll()
            if let allValue = snapshot.value as? NSDictionary {
            for key in allValue{
                let idRoom = key.key as! String
                let val = allValue[idRoom] as! NSDictionary
                let autorChat = val["AutorID"] as? String
                let titleChat = val["Title"] as? String
                let autorName = val["AutorName"] as? String
                let newRoom = Room(id: idRoom, titleRoom: titleChat!, autorID: autorChat!, autorName: autorName!)
                Room.AllRoom.append(newRoom)
                Room.AllRoom.reverse() //Переворачивает массив, что-бы последний созданный чат был первым в списке
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
            }
          }
        }
    }
    
    //Создание новой комнаты
    final func CreateNewRoom(title: String){
        let idChat = self.ref.childByAutoId().key
        let newRoomDic: NSDictionary = [
                                    "Title" : title,
                                    "AutorID" : myID,
                                    "AutorName" : MyName,]
       self.ref.child("ChatRoom").child(idChat).setValue(newRoomDic)
    }
    
    //Удаление команты
    
    final func deleteRoom(to idRoom: String) {
        self.ref.child("ChatRoom").child(idRoom).removeValue()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
    }
    
    //Возвращает мои комнаты, если успею сделаю редактирование/удаление своих комнат
    final func MyRooms() -> [Room] {
       return Room.AllRoom.filter {$0.autorID == myID}}
}



class Room {
    let id: String
    var titleRoom: String
    let autorID: String
    let autorName: String
    static var AllRoom: [Room] = []
    
    init(id: String, titleRoom: String, autorID:String, autorName: String) {
        self.id = id
        self.titleRoom = titleRoom
        self.autorID = autorID
        self.autorName = autorName
    }
}
