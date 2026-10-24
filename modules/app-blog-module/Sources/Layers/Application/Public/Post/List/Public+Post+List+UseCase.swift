//
//  Public+Post+List+UseCase.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import FeatherModuleKit
import Foundation
import WebApplication

extension Public.Post.List {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(
            query: any QueryExecutor<Scope>
        ) {
            self.query = query
        }

        public func execute(input: Input) async throws -> Output {
            let now = Date()
            let items = try await query.run { scope in
                let posts = try await scope.postList.list()
                var result: [Public.Post.Summary.Item] = []
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
            return .init(items: items)
        }
    }

}

extension UseCase {
    fileprivate static func publicAuthors(
        _ ids: [String],
        now: Date,
        context: Scope
    ) async throws -> [Public.Author.Summary.Item] {
        var result: [Public.Author.Summary.Item] = []
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
        context: Scope
    ) async throws -> [Public.Tag.Summary.Item] {
        var result: [Public.Tag.Summary.Item] = []
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
