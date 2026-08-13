//
//  GetPublicPost.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import WebApplication

public struct GetPublicPost {
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
    ) async throws -> PublicBlogPostDetail {
        let now = Date()
        return try await query.run { scope in
            guard
                let metadata = try await scope.metadata.find(
                    referenceType: "blog.post",
                    referenceID: id
                ),
                metadata.isDirectlyAccessible(at: now)
            else {
                throw Error(message: "Post not found")
            }

            let postID = id
            let post = try await scope.post.find(id: postID)
            var authors: [PublicBlogAuthorSummary] = []
            for authorID in post.authorIds {
                guard
                    let authorMetadata = try await scope.metadata.find(
                        referenceType: "blog.author",
                        referenceID: authorID
                    ),
                    authorMetadata.isPublic(at: now)
                else {
                    continue
                }
                let author = try await scope.author.find(id: authorID)
                authors.append(
                    .init(
                        id: author.id,
                        name: author.name,
                        excerpt: author.excerpt,
                        content: author.content,
                        imageAssetId: author.profileImageAssetId,
                        imageURL: "",
                        media: nil,
                        metadata: authorMetadata
                    )
                )
            }

            var tags: [PublicBlogTagSummary] = []
            for tagID in post.tagIds {
                guard
                    let tagMetadata = try await scope.metadata.find(
                        referenceType: "blog.tag",
                        referenceID: tagID
                    ),
                    tagMetadata.isPublic(at: now)
                else {
                    continue
                }
                let tag = try await scope.tag.find(id: tagID)
                tags.append(
                    .init(
                        id: tag.id,
                        title: tag.title,
                        excerpt: tag.excerpt,
                        imageAssetId: tag.imageAssetId,
                        imageURL: "",
                        media: nil,
                        metadata: tagMetadata
                    )
                )
            }

            let relatedPosts = try await Self.relatedPosts(
                authorIDs: post.authorIds,
                tagIDs: post.tagIds,
                excluding: post.id,
                now: now,
                context: scope
            )

            return .init(
                id: post.id,
                title: post.title,
                excerpt: post.excerpt,
                content: post.content,
                imageAssetId: post.imageAssetId,
                imageURL: "",
                media: nil,
                metadata: metadata,
                authors: authors,
                tags: tags,
                relatedPosts: relatedPosts
            )
        }
    }
}

extension GetPublicPost {
    fileprivate static func relatedPosts(
        authorIDs: [String],
        tagIDs: [String],
        excluding postID: String,
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
        for item in posts.items where item.id != postID {
            let candidate = try await context.post.find(id: item.id)
            guard
                candidate.authorIds.contains(where: authorIDs.contains)
                    || candidate.tagIds.contains(where: tagIDs.contains),
                let metadata = try await context.metadata.find(
                    referenceType: "blog.post",
                    referenceID: item.id
                ),
                metadata.isPublic(at: now)
            else { continue }
            result.append(
                .init(
                    id: candidate.id,
                    title: candidate.title,
                    excerpt: candidate.excerpt,
                    imageAssetId: candidate.imageAssetId,
                    imageURL: "",
                    media: nil,
                    metadata: metadata
                )
            )
        }
        return result
    }
}
