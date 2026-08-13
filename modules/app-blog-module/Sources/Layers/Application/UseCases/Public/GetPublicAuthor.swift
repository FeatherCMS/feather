//
//  GetPublicAuthor.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import WebApplication

public struct GetPublicAuthor {
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
    ) async throws -> PublicBlogAuthorDetail {
        let now = Date()
        return try await query.run { scope in
            guard
                let metadata = try await scope.metadata.find(
                    referenceType: "blog.author",
                    referenceID: id
                ),
                metadata.isDirectlyAccessible(at: now)
            else {
                throw Error(message: "Author not found")
            }

            let authorID = id
            let author = try await scope.author.find(id: authorID)
            let links = try await scope.authorLink.list(
                authorId: authorID,
                query: .init(
                    page: .init(size: 10_000, number: 1),
                    sort: [.init(field: .priority, direction: .asc)]
                )
            )
            let posts = try await Self.publicPosts(
                matchingAuthorID: authorID,
                now: now,
                context: scope
            )
            return .init(
                id: author.id,
                name: author.name,
                excerpt: author.excerpt,
                content: author.content,
                imageAssetId: author.profileImageAssetId,
                imageURL: "",
                media: nil,
                metadata: metadata,
                links: links.items.map {
                    .init(label: $0.label, url: $0.url, isBlank: $0.isBlank)
                },
                posts: posts
            )
        }
    }
}

extension GetPublicAuthor {
    fileprivate static func publicPosts(
        matchingAuthorID authorID: String,
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
            guard post.authorIds.contains(authorID) else {
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
