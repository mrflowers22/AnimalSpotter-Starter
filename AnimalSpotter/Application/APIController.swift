//
//  APIController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class APIController {
    
    private let baseUrl = URL(string: "https://lambdaanimalspotter.vapor.cloud/api")!
    var bearer: Bearer? //when class is initiated it wont have a value but we will gve it one later
    
    // create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        //get the url
        let signUpURL = baseUrl.appendingPathComponent("users/signup") //this is the "endpoint" on the api documentation
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") //http has a header section and a body section. the body is going to of type json,
        
        let je = JSONEncoder()
        
        do {
            let jsonData = try je.encode(user)
           request.httpBody = jsonData
            //no completion block here because we want to run the urlsesson later
        } catch  {
            print("Error encoding our httpbody: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            //this is an error from the server
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            //this error happend on the ios not the server
            if let error = error {
                print("Error wth the first data task session: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            //no data to assign to a data source, we didnt get data back.
            completion(nil)
        }.resume()
    }
    
    // create function for sign in
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        //get the url
        let signInURL = baseUrl.appendingPathComponent("users/login") //this is the "endpoint" on the api documentation
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") //http has a header section and a body section. the body is going to of type json,
        
        let je = JSONEncoder()
        
        do {
            let jsonData = try je.encode(user)
            request.httpBody = jsonData
            //no completion block here because we want to run the urlsesson later
        } catch  {
            print("Error encoding our httpbody: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            //this is an error from the server
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            //this error happend on the ios not the server
            if let error = error {
                print("Error wth the first data task session: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            //checking for our data
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let jd = JSONDecoder()
            do {
                //the data we get back per API is a Bearer so we need to decode that
                self.bearer = try jd.decode(Bearer.self, from: data)
            } catch {
                print("Error decoding data we got back: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            completion(nil)
            }.resume()
    }
    
    // create function for fetching all animal names
    
    //create function for fetching a specific animal
    
    // create function to fetch image
}
