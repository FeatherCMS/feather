//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import Leaf

extension BlogAuthorLinkModel: LeafDataRepresentable {
    
    var leafData: LeafData {
        .dictionary([
            "id": id!.uuidString,
            "name": name,
            "url": url,
            "priority": priority,
        ])
    }
}
