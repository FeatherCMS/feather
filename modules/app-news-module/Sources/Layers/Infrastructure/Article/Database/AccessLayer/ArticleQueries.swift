//
//  ArticleQueries.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension ArticleQueries.Row {
    init(from row: any DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        title = try row.decode(column: "title", as: String.self)
        excerpt = try row.decode(column: "excerpt", as: String.self)
        content = try row.decode(column: "content", as: String.self)
        imageAssetId = try row.decode(
            column: "image_asset_id",
            as: String?.self
        )
        createdAt = try row.decode(column: "created_at", as: Date.self)
        updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct ArticleQueries {
    struct Row {
        let id: String
        let title: String
        let excerpt: String
        let content: String
        let imageAssetId: String?
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func listPublic(
        search: String?,
        categoryID: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT news_article.*
                FROM news_article
                INNER JOIN web_metadata
                    ON web_metadata.reference_type = 'news.article'
                    AND web_metadata.reference_id = news_article.id
                WHERE web_metadata.status = 'published'
                    AND web_metadata.publication_date <= NOW()
                    AND (
                        web_metadata.expiration_date IS NULL
                        OR web_metadata.expiration_date > NOW()
                    )
                    AND (
                        \#(categoryID == nil)
                        OR EXISTS (
                            SELECT 1
                            FROM news_article_category
                            WHERE news_article_category.article_id = news_article.id
                                AND news_article_category.category_id = \#(categoryID ?? "")
                        )
                    )
                    AND (
                        \#(search == nil)
                        OR LOWER(COALESCE(web_metadata.title_override, news_article.title))
                            LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    )
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit)
                OFFSET \#(offset);
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func listPublicRelated(
        categoryIDs: [String],
        excludingArticleID: String,
        limit: Int,
        orderBy: String
    ) async throws -> [Row] {
        guard !categoryIDs.isEmpty else { return [] }
        return try await connection.run(
            query: #"""
                SELECT news_article.*
                FROM news_article
                INNER JOIN web_metadata
                    ON web_metadata.reference_type = 'news.article'
                    AND web_metadata.reference_id = news_article.id
                WHERE news_article.id <> \#(excludingArticleID)
                    AND web_metadata.status = 'published'
                    AND web_metadata.publication_date <= NOW()
                    AND (
                        web_metadata.expiration_date IS NULL
                        OR web_metadata.expiration_date > NOW()
                    )
                    AND EXISTS (
                        SELECT 1
                        FROM news_article_category
                        WHERE news_article_category.article_id = news_article.id
                            AND news_article_category.category_id IN (\#(categoryIDs))
                    )
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit);
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func countPublic(
        search: String?,
        categoryID: String?
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM news_article
                INNER JOIN web_metadata
                    ON web_metadata.reference_type = 'news.article'
                    AND web_metadata.reference_id = news_article.id
                WHERE web_metadata.status = 'published'
                    AND web_metadata.publication_date <= NOW()
                    AND (
                        web_metadata.expiration_date IS NULL
                        OR web_metadata.expiration_date > NOW()
                    )
                    AND (
                        \#(categoryID == nil)
                        OR EXISTS (
                            SELECT 1
                            FROM news_article_category
                            WHERE news_article_category.article_id = news_article.id
                                AND news_article_category.category_id = \#(categoryID ?? "")
                        )
                    )
                    AND (
                        \#(search == nil)
                        OR LOWER(COALESCE(web_metadata.title_override, news_article.title))
                            LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    );
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return 0
            }
            return try row.decode(column: "count", as: Int.self)
        }
    }

}
