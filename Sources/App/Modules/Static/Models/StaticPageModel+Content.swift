//
//  StaticPageModel+Content.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import FeatherCore

extension StaticPageModel: MetadataChangeDelegate {
    
    var slug: String { title.slugify() }
    
    func willUpdate(_ metadata: Metadata) {
        if !metadata.$id.exists || (metadata.$id.exists && !metadata.slug.isEmpty) {
            metadata.slug = slug
        }
        metadata.title = title
    }
}
