//
//  BlogPostModel+Metadata.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

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

