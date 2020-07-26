//
//  UserModel+View.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 02..
//

import Vapor
import ViewKit

extension UserModel: ViewContextRepresentable {

    struct ViewContext: Encodable {
        let id: String
        let email: String
        
        init(model: UserModel) {
            self.id = model.id!.uuidString
            self.email = model.email
        }
    }

    var viewContext: ViewContext { .init(model: self) }
}

extension UserModel: FormFieldOptionRepresentable {

    var formFieldOption: FormFieldOption {
        .init(key: self.viewIdentifier, label: self.email)
    }
}
