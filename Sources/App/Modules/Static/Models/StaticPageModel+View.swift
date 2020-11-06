//
//  StaticPageModel+View.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import Leaf

extension StaticPageModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "title": title,
            "content": content,
        ])
    }    
}
