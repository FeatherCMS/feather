//
//  BlogAuthorModel+Metadata.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import FeatherCore

extension BlogAuthorModel: MetadataChangeDelegate {

    var slug: String { Self.name + "/" + name.slugify() }

    func willUpdate(_ metadata: Metadata) {
        metadata.slug = slug
        metadata.title = name
        metadata.excerpt = bio
        metadata.imageKey = imageKey
    }
}
