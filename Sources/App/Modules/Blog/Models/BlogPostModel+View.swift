//
//  BlogPostModel+View.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 13..
//

import FeatherCore

extension BlogPostModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "title": title,
            "imageKey": imageKey,
            "excerpt": excerpt,
            "content": content,
            "category": $category.value != nil ? category : nil,
            "author": $author.value != nil ? author : nil,
        ])
    }
}
