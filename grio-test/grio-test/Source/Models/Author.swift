//
//  Author.swift
//  grio-test
//
//  Created by Glauco Valdes on 9/26/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

struct Author{
    let id: String
    let username: String
    let name: String
    let lastName: String
    let email: String
    let avatar: String
}

extension Author : Decodable{
    enum AuthorCodingKeys: String, CodingKey{
        case id
        case username
        case name
        case lastName
        case email
        case avatar
    }
    
    init(from decoder: Decoder)throws{
        let container = try decoder.container(keyedBy: AuthorCodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        name = try container.decode(String.self, forKey: .name)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decode(String.self, forKey: .email)
        avatar = try container.decode(String.self, forKey: .avatar)
        
    }
}
