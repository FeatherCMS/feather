//
//  GetPublicTag.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import WebApplication

public struct GetPublicTag {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let query: any QueryExecutor<ReadPublic>

    public init(
        query: any QueryExecutor<ReadPublic>
    ) {
        self.query = query
    }

    public func execute(
        id: String
    ) async throws -> PublicBlogTagDetail {
        let now = Date()
        return try await query.run { scope in
            guard
                let metadata = try await scope.metadata.find(
                    referenceType: "blog.tag",
                    referenceID: id
                ),
                metadata.isDirectlyAccessible(at: now)
            else {
                throw Error(message: "Tag not found")
            }

            let tagID = id
            let tag = try await scope.tag.find(id: tagID)
            let posts = try await Self.publicPosts(
                matchingTagID: tagID,
                now: now,
                context: scope
            )
            return .init(
                id: tag.id,
                title: tag.title,
                excerpt: tag.excerpt,
                content: tag.content,
                imageAssetId: tag.imageAssetId,
                imageURL: "",
                media: nil,
                metadata: metadata,
                posts: posts
            )
        }
    }
}

extension GetPublicTag {
    fileprivate static func publicPosts(
        matchingTagID tagID: String,
        now: Date,
        context: ReadPublic
    ) async throws -> [PublicBlogPostSummary] {
        let posts = try await context.post.list(
            query: .init(
                page: .init(size: 10_000, number: 1),
                sort: [.init(field: .createdAt, direction: .desc)]
            )
        )
        var result: [PublicBlogPostSummary] = []
        for item in posts.items {
            let post = try await context.post.find(id: item.id)
            guard post.tagIds.contains(tagID) else {
                continue
            }
            guard
                let metadata = try await context.metadata.find(
                    referenceType: "blog.post",
                    referenceID: item.id
                ),
                metadata.isPublic(at: now)
            else {
                continue
            }
            result.append(
                .init(
                    id: item.id,
                    title: item.title,
                    excerpt: item.excerpt,
                    imageAssetId: post.imageAssetId,
                    imageURL: "",
                    media: nil,
                    metadata: metadata
                )
            )
        }
        return result
    }
}
