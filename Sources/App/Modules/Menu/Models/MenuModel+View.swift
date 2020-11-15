//
//  MenuModel+View.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import FeatherCore

extension MenuModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "handle": handle,
            "name": name,
            "icon": icon,
        ])
    }
}
