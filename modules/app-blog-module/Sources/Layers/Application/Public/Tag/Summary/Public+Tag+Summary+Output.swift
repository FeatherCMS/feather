//
//  Public.Tag.Summary.Output.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import WebApplication
public import WebDomain

extension Public.Tag.Summary {
    public struct Output: DTO {
        public let id: String
        public let title: String
        public let excerpt: String
        public let imageAssetId: String?
        public let imageURL: String
        public let media: WebApplication.Public.Page.Detail.Output.Media?
        public let metadata: Metadata.Detail.Output

        public init(
            id: String,
            title: String,
            excerpt: String,
            imageAssetId: String?,
            imageURL: String,
            media: WebApplication.Public.Page.Detail.Output.Media?,
            metadata: Metadata.Detail.Output
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.imageAssetId = imageAssetId
            self.imageURL = imageURL
            self.media = media
            self.metadata = metadata
        }
    }
}
