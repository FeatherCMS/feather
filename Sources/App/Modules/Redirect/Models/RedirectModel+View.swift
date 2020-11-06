//
//  RedirectModel+View.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 02..
//

import FeatherCore

extension RedirectModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "source": source,
            "destination": destination,
            "statusCode": statusCode,
        ])
    }
}
