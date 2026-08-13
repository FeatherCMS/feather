//
//  CategoryDetail.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import WebApplication

import struct Foundation.Date

public struct CategoryDetail: DTO {
    public let id: String
    public let title: String
    public let excerpt: String
    public let content: String
    public let imageAssetId: String?
    public let metadata: MetadataDetail
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        title: String,
        excerpt: String,
        content: String,
        imageAssetId: String?,
        metadata: MetadataDetail,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.title = title
        self.excerpt = excerpt
        self.content = content
        self.imageAssetId = imageAssetId
        self.metadata = metadata
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
