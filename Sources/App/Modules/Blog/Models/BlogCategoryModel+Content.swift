//
//  BlogCategoryModel+Content.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import FeatherCore

extension BlogCategoryModel: MetadataChangeDelegate {
    
    var slug: String { Self.name + "/" + title.slugify() }
    
    func willUpdate(_ content: Metadata) {
        content.slug = slug
        content.title = title
    }
}

