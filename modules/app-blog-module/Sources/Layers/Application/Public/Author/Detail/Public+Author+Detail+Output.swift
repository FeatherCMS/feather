//
//  Public.Author.Detail.Output.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import WebApplication
public import WebDomain

extension Public.Author.Detail {
    public struct Output: DTO {
        public let id: String
        public let name: String
        public let excerpt: String
        public let content: String
        public let imageAssetId: String?
        public let imageURL: String
        public let media: WebApplication.Public.Page.Detail.Output.Media?
        public let metadata: Metadata.Detail.Output
        public let links: [Public.Author.Link]
        public let posts: [Public.Post.Summary.Output]

        public init(
            id: String,
            name: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            imageURL: String,
            media: WebApplication.Public.Page.Detail.Output.Media?,
            metadata: Metadata.Detail.Output,
            links: [Public.Author.Link],
            posts: [Public.Post.Summary.Output]
        ) {
            self.id = id
            self.name = name
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.imageURL = imageURL
            self.media = media
            self.metadata = metadata
            self.links = links
            self.posts = posts
        }
    }
}
