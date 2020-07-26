//
//  BlogAuthorModel+Content.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import Vapor
import Fluent
import ViperKit

extension BlogAuthorModel: FrontendContentModelDelegate {

    var slug: String { Self.name + "/" + self.name.slugify() }

    func willUpdate(_ content: FrontendContentModel) {
        content.slug = self.slug
        content.title = self.name
        content.excerpt = self.bio
        content.imageKey = self.imageKey
    }
}
