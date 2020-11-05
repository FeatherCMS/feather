//
//  UserModel+View.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 02..
//

import Vapor
import Leaf
import ViewKit

extension UserModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id!.uuidString,
            "email": email,
        ])
    }
}

extension UserModel: FormFieldStringOptionRepresentable {

    var formFieldStringOption: FormFieldStringOption {
        .init(key: id!.uuidString, label: email)
    }
}
