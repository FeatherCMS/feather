//
//  ListPublicCategories.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import Foundation
import NewsDomain
import WebApplication

public struct ListPublicCategories {
    let query: any QueryExecutor<ReadPublicNewsCategory>

    public init(
        query: any QueryExecutor<ReadPublicNewsCategory>
    ) {
        self.query = query
    }

    public func execute() async throws -> [PublicNewsCategorySummary] {
        let now = Date()
        return try await query.run { scope in
            let categories = try await scope.category.list(
                query: .init(
                    page: .init(size: 10000, number: 1),
                    sort: [.init(field: .createdAt, direction: .desc)]
                )
            )
            var result: [PublicNewsCategorySummary] = []
            for item in categories.items {
                guard
                    let metadata = try await scope.metadata.find(
                        referenceType: "news.category",
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
