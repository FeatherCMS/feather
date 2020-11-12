//
//  BlogAuthorLinkModel+View.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import FeatherCore

extension BlogAuthorLinkModel: LeafDataRepresentable {
    
    var leafData: LeafData {
        .dictionary([
            "id": id,
            "name": name,
            "url": url,
            "priority": priority,
        ])
    }
}
