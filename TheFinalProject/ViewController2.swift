//
//  ViewController2.swift
//  finalProject
//
//  Created by 承哲李 on 2018/1/8.
//  Copyright © 2018年 OREO black cool. All rights reserved.
//

import UIKit
import SocketIO


class ViewController2: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var nameArray = [String]()
    var chatArray = [String]()
    var Name:String = ""
    var Lang:String = ""
    var myName:String = ""
    var myLang:String = ""
    var ifInit = 0
    
    let manager = SocketManager(socketURL: URL(string: "http://47.74.176.147:3389")!, config: [.log(true), .compress])
    var socket : SocketIOClient {
        get{
            return manager.defaultSocket
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket.connect()
        myName = Name
        myLang = Lang
        
        socket.on("newChat") {data, ack in
            let newChat = data[0] as? String
            self.chatArray.append(newChat!)
        }
        socket.on("newName") {data, ack in
            let newName = data[0] as? String
            self.nameArray.append(newName!)
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: self.nameArray.count - 1, section: 0), at: .bottom, animated:true)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        socket.emit("sentMessage",["chat":textField.text!,"name":myName])
        textField.text = ""
    }
    
    @IBAction func socketInit(_ sender: Any) {
        if(ifInit == 0){
            textField.placeholder = "Message..."
            socket.emit("init",["lang" : Lang,"name" : Name])
            ifInit += 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.chatLabel.text = chatArray[indexPath.row]
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

