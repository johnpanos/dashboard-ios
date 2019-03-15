//
//  DashboardViewModel.swift
//  Dashboard
//
//  Created by John Panos on 3/14/19.
//  Copyright © 2019 John Panos. All rights reserved.
//

import Foundation
import SwiftSocket

class DashboardViewModel {
    var viewController: DashboardViewController?
    private var dispatchSource: DispatchSourceTimer?
    
    init(viewController: DashboardViewController) {
        self.viewController = viewController
        let server = TCPServer(address: "127.0.0.1", port: 5000)
        switch server.listen() {
        case .success:
            self.dispatchSource = DispatchSource.makeTimerSource()
            self.dispatchSource?.schedule(deadline: .now() + 1/30, repeating: 1/30)
            print("Listening...")
            self.dispatchSource?.setEventHandler(handler: {
                if let client = server.accept() {
                    self.listeningService(client: client)
                } else {
                    print("accept error")
                }
            })
            self.dispatchSource?.resume()
        case .failure(let error):
            print(error)
        }
    }
    
    private func listeningService(client: TCPClient) {
        print("new command from: \(client.address)[\(client.port)]")
        if let input = client.read(1024*5) {
            if let string = String(bytes: input, encoding: .utf8) {
                print(string)
                let inputArray = string.components(separatedBy: ":")
                let key = inputArray[0]
                let value = inputArray[1]
                print("key: " + inputArray[0])
                print("value: " + inputArray[1])
                switch key {
                case "alliance":
                    if value == "Red" {
                        viewController?.setBackgroundColorRed()
                    } else {
                        viewController?.setBackgroundColorBlue()
                    }
                    break
                case "displayAutoPath":
                    if value == "true" {
                        viewController?.showField()
                    } else {
                        viewController?.hideField()
                    }
                    break
                default:
                    print("unknown oof")
                    break
                }
            } else {
                print("not a valid UTF-8 sequence")
            }
        }
        client.close()
    }
}
