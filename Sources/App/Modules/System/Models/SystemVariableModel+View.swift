//
//  SystemVariableModel+View.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 10..
//

import Vapor
import ViewKit

extension SystemVariableModel: ViewContextRepresentable {

    struct ViewContext: Encodable {
        var id: String
        var key: String
        var value: String
        var hidden: Bool
        var notes: String?
        
        init(model: SystemVariableModel) {
            self.id = model.id!.uuidString
            self.key = model.key
            self.value = model.value
            self.hidden = model.hidden
            self.notes = model.notes
        }
    }

    var viewContext: ViewContext { .init(model: self) }
}
