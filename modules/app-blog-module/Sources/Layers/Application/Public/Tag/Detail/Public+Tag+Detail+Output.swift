//
//  Public+Tag+Detail+Output.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import WebApplication
import WebDomain
public import WebModule

extension Public.Tag.Detail {
    public struct Output: DTO {
        public let id: String
        public let title: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let imageURL: String
        public let media: WebApplication.Public.Media?
        public let metadata: WebModule.Metadata.Snapshot
        public let posts: [Public.Post.Summary.Item]

        public init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            imageURL: String,
            media: WebApplication.Public.Media?,
            metadata: WebModule.Metadata.Snapshot,
            posts: [Public.Post.Summary.Item]
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
