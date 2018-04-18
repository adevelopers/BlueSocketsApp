//
//  ViewController.swift
//  BlueSocketApp
//
//  Created by Kirill Khudyakov on 19.04.18.
//  Copyright © 2018 adeveloper. All rights reserved.
//

import Cocoa
import Socket

class ViewController: NSViewController {

    let host = "127.0.0.1"
    let port = 31337
    var continueRunning: Bool = true
    var listenSocket: Socket!
    var clientSockets =  [Socket]()
    
    deinit {
        self.clientSockets.forEach {
            $0.close()
        }
        
        self.listenSocket.close()
    }

    
    @IBAction func tapConnect(_ sender: Any) {
        
        do {
            
            let socket = try Socket.create()
            try   socket.connect(to: host, port: Int32(port) )
            try   socket.write(from: "hello cyberbob")
            
        } catch (let e) {
            print("socket exception")
            print(e.localizedDescription)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        queue.async { [unowned self] in
            
            do {
                self.listenSocket = try Socket.create()
                try self.listenSocket.listen(on: self.port)

                repeat {
                    let newSocket = try self.listenSocket.acceptClientConnection()
                    
                    print("Accepted connection from: \(newSocket.remoteHostname) on port \(newSocket.remotePort)")
                    print("Socket Signature: \(newSocket.signature?.description ?? "")")
                    
                    self.clientSockets.append(newSocket)
                } while self.continueRunning

            } catch (let e) {
                print("socket exception")
                print(e.localizedDescription)
            }
        }
        
    }

    override var representedObject: Any? {
        didSet {
       
        }
    }


}

