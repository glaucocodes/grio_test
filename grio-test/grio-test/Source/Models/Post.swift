//
//  Post.swift
//  grio-test
//
//  Created by Glauco Valdes on 9/26/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

struct Post{
    let author: Author
    let message: Message
}

extension Post : Decodable{
    enum PostCodingKeys: String, CodingKey{
        case author
        case message
    }
    
    init(from decoder: Decoder)throws{
        let container = try decoder.container(keyedBy: PostCodingKeys.self)
        
        author = try container.decode(Author.self, forKey: .author)
        message = try container.decode(Message.self, forKey: .message)
    }
}
