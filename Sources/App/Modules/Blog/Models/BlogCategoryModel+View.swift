//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import FeatherCore

extension BlogCategoryModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "title": title,
            "imageKey": imageKey,
            "excerpt": excerpt,
            "priority": priority,
            "posts": $posts.value != nil ? posts : [],
        ])
    }
}

extension BlogCategoryModel: FormFieldStringOptionRepresentable {

    var formFieldStringOption: FormFieldStringOption {
        .init(key: id!.uuidString, label: title)
    }
}
