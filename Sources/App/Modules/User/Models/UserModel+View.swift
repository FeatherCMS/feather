//
//  UserModel+View.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 02..
//

import Vapor
import Leaf
import ViewKit

extension UserModel: LeafDataRepresentable {

    var leafData: LeafData {
        .dictionary([
            "id": id,
            "email": email,
        ])
    }
}

extension UserModel: FormFieldStringOptionRepresentable {

    var formFieldStringOption: FormFieldStringOption {
        .init(key: id!.uuidString, label: email)
    }
}
