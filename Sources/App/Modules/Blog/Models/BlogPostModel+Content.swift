//
//  BlogPostModel+Content.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import Vapor
import Fluent
import ViperKit
import FeatherCore

extension BlogPostModel: MetadataChangeDelegate {
    
    var slug: String { title.slugify() }
    
    func willUpdate(_ content: Metadata) {
        content.slug = slug
        content.title = title
        content.excerpt = excerpt
        content.imageKey = imageKey
    }
}

