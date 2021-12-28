//
//  Rest.swift
//  Carangas
//
//  Created by Victor Feitosa on 28/12/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

enum CarError {
    case url
    case taskError(error: Error)
    case noResponde
    case noData
    case responseStatusCode(code: Int)
    case invalidJson
}

class REST {
    private static let basePath: String = "https://carangas.herokuapp.com/cars"
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false //bloquear 3g ou 4g - somente wifi
        config.httpAdditionalHeaders = ["Content-Type": "application/json"] //Header HTTP
        config.timeoutIntervalForRequest = 30.0 //TIMEOUT DEFINIDO POR CLIENTE, CASO EM 30 SEGUNDOS ELE CANCELA
        config.httpMaximumConnectionsPerHost = 5
        return config
        
    }()
    
    private static let session = URLSession(configuration: configuration) //URLSession.shared
    
    class func loadCard(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void){
        guard let url = URL(string: basePath) else {
            onError(.url)
            return
        }
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponde)
                    return
                }
                
                if response.statusCode == 200 {
                    
                    guard let data = data else {
                        return
                    }
                    
                    do{
                        let cars = try JSONDecoder().decode([Car].self, from: data)
                        onComplete(cars)
                    }catch{
                        print(error.localizedDescription)
                        onError(.invalidJson)
                    }
                    
                }else {
                    onError(.responseStatusCode(code: response.statusCode))
                }
                

            }else {
                onError(.taskError(error: error!))
            }
        }
        
        dataTask.resume()
    }
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void){
        guard let url = URL(string: basePath) else {
            onComplete(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let json = try? JSONEncoder().encode(car) else {
            onComplete(false)
            return
        }
        print(json)
        request.httpBody = json
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if error == nil {
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
                    onComplete(false)
                    return
                }
                onComplete(true)
            }else {
                onComplete(false)
            }
        }
        
        dataTask.resume()
    }
}
