//
//  BlogPostModel+View.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 13..
//

import Vapor
import Leaf

extension BlogPostModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id!.uuidString,
            "title": title,
            "imageKey": imageKey,
            "excerpt": excerpt,
            "content": content,
            
        ])
    }
}
