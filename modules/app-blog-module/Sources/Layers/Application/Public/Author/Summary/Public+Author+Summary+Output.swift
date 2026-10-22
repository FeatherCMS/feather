//
//  Public.Author.Summary.Output.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherApplication
public import WebApplication

extension Public.Author.Summary {
    public struct Output: DTO {
        public let id: String
        public let name: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let imageURL: String
        public let media: PublicContentMedia?
        public let metadata: MetadataDetail

        public init(
            id: String,
            name: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            imageURL: String,
            media: PublicContentMedia?,
            metadata: MetadataDetail
        ) {
            self.id = id
            self.name = name
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.imageURL = imageURL
            self.media = media
            self.metadata = metadata
        }
    }
}
