//
//  MenuModel+View.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import FeatherCore

extension MenuItemModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "icon": icon,
            "label": label,
            "url": url,
            "priority": priority,
            "targetBlank": targetBlank,
        ])
    }
}
