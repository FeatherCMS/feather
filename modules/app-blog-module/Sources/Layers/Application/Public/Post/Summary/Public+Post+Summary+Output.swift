//
//  Public.Post.Summary.Output.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import WebApplication

extension Public.Post.Summary {
    public struct Output: DTO {
        public let id: String
        public let title: String
        public let excerpt: String
        public let imageAssetId: String?
        public let imageURL: String
        public let media: PublicContentMedia?
        public let metadata: MetadataDetail
        public let authors: [Public.Author.Summary.Output]
        public let tags: [Public.Tag.Summary.Output]

        public init(
            id: String,
            title: String,
            excerpt: String,
            imageAssetId: String?,
            imageURL: String,
            media: PublicContentMedia?,
            metadata: MetadataDetail,
            authors: [Public.Author.Summary.Output] = [],
            tags: [Public.Tag.Summary.Output] = []
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.imageAssetId = imageAssetId
            self.imageURL = imageURL
            self.media = media
            self.metadata = metadata
            self.authors = authors
            self.tags = tags
        }
    }
}
