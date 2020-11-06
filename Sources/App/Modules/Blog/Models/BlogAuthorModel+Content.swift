//
//  BlogAuthorModel+Content.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import Vapor
import Fluent
import ViperKit
import FeatherCore

extension BlogAuthorModel: MetadataChangeDelegate {

    var slug: String { Self.name + "/" + name.slugify() }

    func willUpdate(_ content: Metadata) {
        content.slug = slug
        content.title = name
        content.excerpt = bio
        content.imageKey = imageKey
    }
}
