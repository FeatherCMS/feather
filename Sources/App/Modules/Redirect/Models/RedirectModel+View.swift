//
//  RedirectModel.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 02..
//

import Vapor
import ViewKit

extension RedirectModel: ViewContextRepresentable {

    struct ViewContext: Encodable {
        var id: String
        var source: String
        var destination: String
        var statusCode: Int

        init(model: RedirectModel) {
            self.id = model.id!.uuidString
            self.source = model.source
            self.destination = model.destination
            self.statusCode = model.statusCode
        }
    }
    
    var viewContext: ViewContext { .init(model: self) }
}
