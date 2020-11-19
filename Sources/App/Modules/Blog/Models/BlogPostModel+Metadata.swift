//
//  BlogPostModel+Metadata.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import FeatherCore

extension BlogPostModel: MetadataChangeDelegate {
    
    var slug: String { title.slugify() }
    
    func willUpdate(_ metadata: Metadata) {
        metadata.slug = slug
        metadata.title = title
        metadata.excerpt = excerpt
        metadata.imageKey = imageKey
    }
}

