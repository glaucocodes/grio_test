//
//  Body.swift
//  grio-test
//
//  Created by Glauco Valdes on 9/26/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

struct Body{
    let image: String
    let text: String
}

extension Body : Decodable{
    enum BodyCodingKeys: String, CodingKey{
        case image
        case text
    }
    
    init(from decoder: Decoder)throws{
        let container = try decoder.container(keyedBy: BodyCodingKeys.self)
        
        image = try container.decode(String.self, forKey: .image)
        text = try container.decode(String.self, forKey: .text)
    }
}
