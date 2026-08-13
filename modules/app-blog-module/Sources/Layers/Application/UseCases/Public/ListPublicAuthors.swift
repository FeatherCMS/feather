//
//  ListPublicAuthors.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import Foundation
import WebApplication

public struct ListPublicAuthors {
    let query: any QueryExecutor<ReadPublic>

    public init(
        query: any QueryExecutor<ReadPublic>
    ) {
        self.query = query
    }

    public func execute() async throws -> [PublicBlogAuthorSummary] {
        let now = Date()
        return try await query.run { scope in
            let authors = try await scope.author.list(
                query: .init(
                    page: .init(size: 10_000, number: 1),
                    sort: [.init(field: .createdAt, direction: .desc)]
                )
            )
            var result: [PublicBlogAuthorSummary] = []
            for item in authors.items {
                guard
                    let metadata = try await scope.metadata.find(
                        referenceType: "blog.author",
                        referenceID: item.id
                    ),
                    metadata.isPublic(at: now)
                else {
                    continue
                }
                let author = try await scope.author.find(id: item.id)
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
    }
}
