//
//  BlogCategoryModel+Content.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import Vapor
import Fluent
import ViperKit

extension BlogCategoryModel: FrontendContentModelDelegate {
    
    var slug: String { Self.name + "/" + self.title.slugify() }
    
    func willUpdate(_ content: FrontendContentModel) {
        content.slug = self.slug
        content.title = self.title
    }
}

