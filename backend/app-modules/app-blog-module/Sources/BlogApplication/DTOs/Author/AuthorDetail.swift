//
//  AuthorDetail.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import WebApplication

import struct Foundation.Date

public struct AuthorDetail: DTO {
    public let id: String
    public let name: String
    public let excerpt: String
    public let content: String
    public let profileImageAssetId: String?
    public let metadata: MetadataDetail
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String,
        excerpt: String,
        content: String,
        profileImageAssetId: String?,
        metadata: MetadataDetail,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.excerpt = excerpt
        self.content = content
        self.profileImageAssetId = profileImageAssetId
        self.metadata = metadata
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
