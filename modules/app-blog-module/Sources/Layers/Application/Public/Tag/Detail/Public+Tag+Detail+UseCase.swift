//
//  Public+Tag+Detail+UseCase.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import FeatherModuleKit
import Foundation
import WebApplication

extension Public.Tag.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(
            query: any QueryExecutor<Scope>
        ) {
            self.query = query
        }

        public func execute(input: Input) async throws -> Output {
            let id = input.id
            let now = Date()
            return try await query.run { scope in
                guard
                    let metadata = try await scope.metadata.find(
                        referenceType: "blog.tag",
                        referenceID: id
                    ),
                    metadata.isDirectlyAccessible(at: now)
                else {
                    throw Public.Tag.Detail.Error(message: "Tag not found")
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
}

extension UseCase {
    fileprivate static func publicPosts(
        matchingTagID tagID: String,
        now: Date,
        context: Scope
    ) async throws -> [Public.Post.Summary.Item] {
        let posts = try await context.postList.list()
        var result: [Public.Post.Summary.Item] = []
        for item in posts.items {
            let post = try await context.postDetail.find(id: item.id)
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
