//
//  ResponsePost.swift
//  grio-test
//
//  Created by Glauco Valdes on 9/26/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

struct ResponsePost{
    let token: String
    let id: String
    var posts: [Post]
}

extension ResponsePost : Decodable{
    enum ResponsePostCodingKeys: String, CodingKey{
        case token
        case id
        case posts
    }
    
    init(from decoder: Decoder)throws{
        let container = try decoder.container(keyedBy: ResponsePostCodingKeys.self)
        
        token = try container.decode(String.self, forKey: .token)
        id = try container.decode(String.self, forKey: .id)
        posts = try container.decode([Post].self, forKey: .posts)
    }
}
