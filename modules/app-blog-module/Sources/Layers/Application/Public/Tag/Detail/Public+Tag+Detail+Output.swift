//
//  Public.Tag.Detail.Output.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherApplication
public import WebApplication

extension Public.Tag.Detail {
    public struct Output: DTO {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let imageURL: String
        public let media: PublicContentMedia?
        public let metadata: MetadataDetail
        public let posts: [Public.Post.Summary.Output]

        public init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            imageURL: String,
            media: PublicContentMedia?,
            metadata: MetadataDetail,
            posts: [Public.Post.Summary.Output]
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.imageURL = imageURL
            self.media = media
            self.metadata = metadata
            self.posts = posts
        }
    }
}
