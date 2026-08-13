//
//  ListPublicPosts.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import Foundation
import WebApplication

public struct ListPublicPosts {
    let query: any QueryExecutor<ReadPublic>

    public init(
        query: any QueryExecutor<ReadPublic>
    ) {
        self.query = query
    }

    public func execute() async throws -> [PublicBlogPostSummary] {
        let now = Date()
        return try await query.run { scope in
            let posts = try await scope.post.list(
                query: .init(
                    page: .init(size: 10_000, number: 1),
                    sort: [.init(field: .createdAt, direction: .desc)]
                )
            )
            var result: [PublicBlogPostSummary] = []
            for item in posts.items {
                guard
                    let metadata = try await scope.metadata.find(
                        referenceType: "blog.post",
                        referenceID: item.id
                    ),
                    metadata.isPublic(at: now)
                else {
                    continue
                }
                let post = try await scope.post.find(id: item.id)
                let authors = try await Self.publicAuthors(
                    post.authorIds,
                    now: now,
                    context: scope
                )
                let tags = try await Self.publicTags(
                    post.tagIds,
                    now: now,
                    context: scope
                )
                result.append(
                    .init(
                        id: item.id,
                        title: item.title,
                        excerpt: item.excerpt,
                        imageAssetId: item.imageAssetId,
                        imageURL: "",
                        media: nil,
                        metadata: metadata,
                        authors: authors,
                        tags: tags
                    )
                )
            }
            return result
        }
    }
}

extension ListPublicPosts {
    fileprivate static func publicAuthors(
        _ ids: [String],
        now: Date,
        context: ReadPublic
    ) async throws -> [PublicBlogAuthorSummary] {
        var result: [PublicBlogAuthorSummary] = []
        for id in ids {
            guard
                let metadata = try await context.metadata.find(
                    referenceType: "blog.author",
                    referenceID: id
                ),
                metadata.isPublic(at: now)
            else { continue }
            let author = try await context.author.find(id: id)
            result.append(
                .init(
                    id: author.id,
                    name: author.name,
                    excerpt: author.excerpt,
                    content: author.content,
                    imageAssetId: author.profileImageAssetId,
                    imageURL: "",
                    media: nil,
                    metadata: metadata
                )
            )
        }
        return result
    }

    fileprivate static func publicTags(
        _ ids: [String],
        now: Date,
        context: ReadPublic
    ) async throws -> [PublicBlogTagSummary] {
        var result: [PublicBlogTagSummary] = []
        for id in ids {
            guard
                let metadata = try await context.metadata.find(
                    referenceType: "blog.tag",
                    referenceID: id
                ),
                metadata.isPublic(at: now)
            else { continue }
            let tag = try await context.tag.find(id: id)
            result.append(
                .init(
                    id: tag.id,
                    title: tag.title,
                    excerpt: tag.excerpt,
                    imageAssetId: tag.imageAssetId,
                    imageURL: "",
                    media: nil,
                    metadata: metadata
                )
            )
        }
        return result
    }
}
