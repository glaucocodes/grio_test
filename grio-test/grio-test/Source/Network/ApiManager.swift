//
//  ApiManager.swift
//  grio-test
//
//  Created by Glauco Valdes on 9/26/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

import Foundation
class ApiManager: NSObject {
    
    static let sharedInstance = ApiManager()
    
    func getPost(index : Int,filter : String, completion: @escaping (ResponsePost) -> Void ) {
        var returnValue = ResponsePost(token: "", id: "", posts: [])
        if let url = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                returnValue = try decoder.decode(ResponsePost.self, from: data)
               
                
                switch (filter){
                    case "Date":
                        returnValue.posts = returnValue.posts.sorted{$0.message.date > $1.message.date}
                    case "Likes":
                        returnValue.posts = returnValue.posts.sorted{$0.message.likes > $1.message.likes}
                    case "Views":
                        returnValue.posts = returnValue.posts.sorted{$0.message.views > $1.message.views}
                    case "Lenght":
                        returnValue.posts = returnValue.posts.sorted{$0.message.body.text.count > $1.message.body.text.count}
                    default:
                        break
                }
            
                
                let tempIndexStart = index  * 10
                var tempIndexEnd = tempIndexStart + 9
                if( tempIndexEnd > returnValue.posts.count ){
                    tempIndexEnd = (returnValue.posts.count - tempIndexStart - 1) + tempIndexStart
                }
                
                //print("\nStart Index " + String(tempIndexStart))
                //print("End Index " + String(tempIndexEnd))
                
                
                
                if(tempIndexEnd < returnValue.posts.count && tempIndexStart < returnValue.posts.count){
                    returnValue.posts = Array(returnValue.posts[tempIndexStart...tempIndexEnd])
                }else{
                    returnValue.posts = [Post]()
                }
                completion(returnValue)
            } catch {
                print("error:\(error)")
                completion(returnValue)
            }
        }
    }
}
