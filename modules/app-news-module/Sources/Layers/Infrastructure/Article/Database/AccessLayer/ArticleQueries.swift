//
//  ArticleQueries.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure
import NewsApplication
import NewsDomain
import NewsModule

struct ArticleQueries {
    let connection: any DatabaseConnection

    func orderByPublicArticle(_ query: Public.Article.List.Input.Query)
        -> String
    {
        let sortParts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .id: column = "id"
            case .title: column = "title"
            case .createdAt: column = "created_at"
            case .updatedAt: column = "updated_at"
            }
            return "\(column) \(rule.direction == .asc ? "ASC" : "DESC")"
        }
        return (sortParts + [defaultPublicOrderByArticle, "id ASC"])
            .joined(separator: ", ")
    }

    var defaultPublicOrderByArticle: String {
        "(SELECT publication_date FROM web_metadata "
            + "WHERE reference_type = 'news.article' "
            + "AND reference_id = news_article.id) DESC NULLS LAST"
    }

    func listPublic(
        search: String?,
        categoryID: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Article.Table.List] {
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
            try await sequence.collect().map { try Article.Table.List(row: $0) }
        }
    }

    func listPublicRelated(
        categoryIDs: [String],
        excludingArticleID: String,
        limit: Int,
        orderBy: String
    ) async throws -> [Article.Table.List] {
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
            try await sequence.collect().map { try Article.Table.List(row: $0) }
        }
    }

    func countPublic(
        search: String?,
        categoryID: String? = nil
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
                        \#(search == nil)
                        OR LOWER(COALESCE(web_metadata.title_override, news_article.title))
                            LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    )
                    AND (
                        \#(categoryID == nil)
                        OR EXISTS (
                            SELECT 1
                            FROM news_article_category
                            WHERE news_article_category.article_id = news_article.id
                                AND news_article_category.category_id = \#(categoryID ?? "")
                        )
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
