//
//  dogAPI.swift
//  doggoAPI
//
//  Created by Jagdeep Singh on 22/02/21.
//

import Foundation
import UIKit

class DogAPI {
    enum Endpoint {
        case randomImageFromAllDogsColection
        case randomImageForBreed(String)
        case listAllBreeds
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsColection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
        
    }
    class func requestBreedsList(completionHandler: @escaping ([String], Error?) -> Void)  {
        let listTask = URLSession.shared.dataTask(with: DogAPI.Endpoint.listAllBreeds.url) { (data, response, error) in
            guard let data = data else {
                completionHandler([],error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let listofbreeds = try decoder.decode(DogList.self, from: data)
                let breeds = listofbreeds.message.keys.map({$0})
                completionHandler(breeds,nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        listTask.resume()
    }
    
    
    class func requestImageFile(url: URL,completionHandler: @escaping (UIImage? , Error?) -> Void){
        let imageTask = URLSession.shared.dataTask(with: url) { (data2, response, error) in
            guard let data2 = data2 else {
                completionHandler(nil,error)
                return
            }
            let image = UIImage(data: data2)
            completionHandler(image,nil)
        }
        imageTask.resume()
        
    }
    class func requestRandomImage( completionHandler: @escaping (DogImage?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: DogAPI.Endpoint.randomImageFromAllDogsColection.url) { (data, response ,error) in
            guard let data = data else {
                completionHandler(nil,error)
            return
         }
            let decoder = JSONDecoder()
            
            let imageData = try! decoder.decode(DogImage.self, from: data)
            completionHandler(imageData,nil)
//                guard let imageUrl = URL(string: imageData.message) else {
//                    return
//                }
            
        }
        task.resume()
    
}
   
    
    
    class func requestRandomBreedImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        
        let breedTask = URLSession.shared.dataTask(with: DogAPI.Endpoint.randomImageForBreed(breed).url) { (data, response ,error) in
            guard let data = data else {
                completionHandler(nil,error)
            return
         }
            let decoder = JSONDecoder()
            
            let imageData = try! decoder.decode(DogImage.self, from: data)
            completionHandler(imageData,nil)

            
        }
        breedTask.resume()
    
}
    
}
