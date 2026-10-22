public import BlogModule
public import FeatherApplication
import FeatherModuleKit
public import WebApplication
import WebDomain
public import WebModule

public import struct Foundation.Date

//
//  Author.Detail.Output.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Author.Detail {
    public struct Output: DTO {
        public let id: String
        public let name: String
        public let excerpt: String
        public let content: String
        public let profileImageAssetId: String?
        public let metadata: WebModule.Metadata.Detail.Output
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            name: String,
            excerpt: String,
            content: String,
            profileImageAssetId: String?,
            metadata: WebModule.Metadata.Detail.Output,
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
}
