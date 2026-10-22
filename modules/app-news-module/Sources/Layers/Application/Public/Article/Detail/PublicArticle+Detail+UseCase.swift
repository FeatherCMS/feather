//
//  GetPublicArticle.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherModuleKit
import Foundation
import NewsModule
import WebApplication
import WebDomain

public struct GetPublicArticle {
    let query: any QueryExecutor<PublicNewsArticle.Detail.Scope>

    public init(
        query: any QueryExecutor<PublicNewsArticle.Detail.Scope>
    ) {
        self.query = query
    }

    public func execute(
        id: String
    ) async throws -> PublicNewsArticle.Detail.Output {
        let now = Date()
        return try await query.run { scope in
            let article = try await scope.article.find(id: id)
            guard article.metadata.isDirectlyAccessible(at: now) else {
                throw Error(message: "Article not found")
            }
            let categories = try await scope.category
                .findCategories(ids: article.categoryIds)
                .filter { $0.metadata.isPublic(at: now) }
                .map {
                    PublicNewsCategory.Summary.Item(
                        id: $0.id,
                        title: $0.title,
                        excerpt: $0.excerpt,
                        imageAssetId: $0.imageAssetId,
                        imageURL: "",
                        media: nil,
                        metadata: $0.metadata
                    )
                }

            return .init(
                id: article.id,
                title: article.title,
                excerpt: article.excerpt,
                content: article.content,
                imageAssetId: article.imageAssetId,
                imageURL: "",
                media: nil,
                metadata: article.metadata,
                categories: categories
            )
        }
    }
}
