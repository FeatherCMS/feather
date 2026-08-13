//
//  ListPublicArticles.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import Foundation
import NewsDomain
import WebApplication

public struct ListPublicArticles {
    let query: any QueryExecutor<ReadPublicNewsArticle>

    public init(
        query: any QueryExecutor<ReadPublicNewsArticle>
    ) {
        self.query = query
    }

    public func execute() async throws -> [PublicNewsArticleSummary] {
        let now = Date()
        return try await query.run { scope in
            let articles = try await scope.article.list(
                query: .init(
                    page: .init(size: 10000, number: 1),
                    sort: [.init(field: .createdAt, direction: .desc)]
                )
            )
            var result: [PublicNewsArticleSummary] = []
            for item in articles.items {
                guard
                    let metadata = try await scope.metadata.find(
                        referenceType: "news.article",
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
                        imageAssetId: item.imageAssetId,
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
