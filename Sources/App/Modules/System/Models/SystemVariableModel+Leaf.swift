//
//  SystemVariableModel+Leaf.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//

import Leaf

extension SystemVariableModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id!.uuidString,
            "key": key,
            "value": value,
            "hidden": hidden,
            "notes": notes,
        ])
    }
}
