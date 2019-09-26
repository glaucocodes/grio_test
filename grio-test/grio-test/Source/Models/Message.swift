//
//  Message.swift
//  grio-test
//
//  Created by Glauco Valdes on 9/26/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//
import Foundation
struct Message{
    let id: String
    let likes: Int
    let views: Int
    let date: Date
    let body: Body
}

extension Message : Decodable{
    enum MessageCodingKeys: String, CodingKey{
        case id
        case likes
        case views
        case date
        case body
    }
    
    init(from decoder: Decoder)throws{
        let container = try decoder.container(keyedBy: MessageCodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        likes = try container.decode(Int.self, forKey: .likes)
        views = try container.decode(Int.self, forKey: .views)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let dateTemp = dateFormatter.date(from: try container.decode(String.self, forKey: .date))!
        
        date = dateTemp
        body = try container.decode(Body.self, forKey: .body)
    }
}
