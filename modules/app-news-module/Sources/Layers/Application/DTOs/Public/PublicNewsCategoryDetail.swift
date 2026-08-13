//
//  PublicNewsCategoryDetail.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import WebApplication

public struct PublicNewsCategoryDetail: DTO {
    public let id: String
    public let title: String
    public let excerpt: String
    public let content: String
    public let imageAssetId: String?
    public let imageURL: String
    public let media: PublicContentMedia?
    public let metadata: MetadataDetail
    public let articles: [PublicNewsArticleSummary]

    public init(
        id: String,
        title: String,
        excerpt: String,
        content: String,
        imageAssetId: String?,
        imageURL: String,
        media: PublicContentMedia?,
        metadata: MetadataDetail,
        articles: [PublicNewsArticleSummary]
    ) {
        self.id = id
        self.title = title
        self.excerpt = excerpt
        self.content = content
        self.imageAssetId = imageAssetId
        self.imageURL = imageURL
        self.media = media
        self.metadata = metadata
        self.articles = articles
    }
}
