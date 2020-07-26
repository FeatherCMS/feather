//
//  BlogPostModel+View.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 13..
//

import Vapor
import ViewKit

extension BlogPostModel: ViewContextRepresentable {

    struct ViewContext: Encodable {
        var id: String
        var title: String
        var imageKey: String
        var excerpt: String
        var content: String

        init(model: BlogPostModel) {
            self.id = model.id!.uuidString
            self.title = model.title
            self.imageKey = model.imageKey
            self.excerpt = model.excerpt
            self.content = model.content
        }
    }

    var viewContext: ViewContext { .init(model: self) }
}
