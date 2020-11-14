//
//  BlogCategoryModel+Metadata.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import FeatherCore

/// this object is used when a metadata is created or updated
extension BlogCategoryModel: MetadataChangeDelegate {
    
    /// the default slug is just a combination of the model name and the slugified title
    var slug: String { Self.name + "/" + title.slugify() }
    
    /// when a category change happens we update the slug and title of the associated metadata
    func willUpdate(_ metadata: Metadata) {
        metadata.slug = slug
        metadata.title = title
    }
}

