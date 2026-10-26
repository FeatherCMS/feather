//
//  Public+Author+Detail+UseCase.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import FeatherModuleKit
import Foundation
import WebApplication

extension Public.Author.Detail {
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
                        referenceType: "blog.author",
                        referenceID: id
                    ),
                    metadata.isDirectlyAccessible(at: now)
                else {
                    throw Error(message: "Author not found")
                }

                let authorID = id
                let author = try await scope.author.find(id: authorID)
                let links = try await scope.author.links(authorID: authorID)
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
                    links: links.map {
                        .init(label: $0.label, url: $0.url, isBlank: $0.isBlank)
                    },
                    posts: posts
                )
            }
        }
    }
}

extension Public.Author.Detail.UseCase {
    fileprivate static func publicPosts(
        matchingAuthorID authorID: String,
        now: Date,
        context: Public.Author.Detail.Scope
    ) async throws -> [Public.Post.Summary.Item] {
        let posts = try await context.author.posts(authorID: authorID)
        var result: [Public.Post.Summary.Item] = []
        for post in posts {
            guard
                let metadata = try await context.metadata.find(
                    referenceType: "blog.post",
                    referenceID: post.id
                ),
                metadata.isPublic(at: now)
            else {
                continue
            }
            result.append(
                .init(
                    id: post.id,
                    title: post.title,
                    excerpt: post.excerpt,
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
