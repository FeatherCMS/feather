//
//  StaticPageModel+View.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import ViewKit

extension StaticPageModel: ViewContextRepresentable {

    struct ViewContext: Encodable {
        var id: String
        var title: String
        var content: String

        init(model: StaticPageModel) {
            self.id = model.id!.uuidString
            self.title = model.title
            self.content = model.content
        }
    }

    var viewContext: ViewContext { .init(model: self) }
}
