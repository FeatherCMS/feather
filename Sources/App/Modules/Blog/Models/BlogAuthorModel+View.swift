//
//  BlogAuthorModel+View.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import FeatherCore

extension BlogAuthorModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id!.uuidString,
            "name": name,
            "imageKey": imageKey,
            "bio": bio,
            "links": $links.value != nil ? links.sorted { $0.priority > $1.priority } : [],
            "posts": $posts.value != nil ? posts : [],
        ])
    }
}

extension BlogAuthorModel: FormFieldStringOptionRepresentable {

    var formFieldStringOption: FormFieldStringOption {
        .init(key: id!.uuidString, label: name)
    }
}
