//
//  Public+Post+Detail+UseCase.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import FeatherModuleKit
import Foundation
import WebApplication

extension Public.Post.Detail {
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
                        referenceType: "blog.post",
                        referenceID: id
                    ),
                    metadata.isDirectlyAccessible(at: now)
                else {
                    throw Error(message: "Post not found")
                }

                let postID = id
                let post = try await scope.post.find(id: postID)
                var authors: [Public.Author.Summary.Item] = []
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
                    let author = try await scope.post.findAuthor(id: authorID)
                    authors.append(
                        .init(
                            id: author.id,
                            name: author.name,
                            excerpt: author.excerpt,
                            content: author.content,
                            imageAssetId: author.imageAssetId,
                            imageURL: "",
                            media: nil,
                            metadata: authorMetadata
                        )
                    )
                }

                var tags: [Public.Tag.Summary.Item] = []
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
                    let tag = try await scope.post.findTag(id: tagID)
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
}

extension Public.Post.Detail.UseCase {
    fileprivate static func relatedPosts(
        authorIDs: [String],
        tagIDs: [String],
        excluding postID: String,
        now: Date,
        context: Public.Post.Detail.Scope
    ) async throws -> [Public.Post.Summary.Item] {
        let candidates = try await context.post.relatedCandidates(
            excludingID: postID
        )
        var result: [Public.Post.Summary.Item] = []
        for candidate in candidates {
            guard
                candidate.authorIds.contains(where: authorIDs.contains)
                    || candidate.tagIds.contains(where: tagIDs.contains),
                let metadata = try await context.metadata.find(
                    referenceType: "blog.post",
                    referenceID: candidate.id
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
