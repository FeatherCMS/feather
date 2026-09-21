import FeatherDatabase
import Foundation

struct ArticleCategoryTable {
    let connection: any DatabaseConnection

    func listCategoryIDs(
        articleID: String
    ) async throws -> [String] {
        try await connection.run(
            query: #"""
                SELECT category_id
                FROM news_article_category
                WHERE article_id = \#(articleID)
                ORDER BY category_id ASC;
                """#
        ) { sequence in
            try await sequence.collect()
                .map {
                    try $0.decode(column: "category_id", as: String.self)
                }
        }
    }

    func listCategoryIDs(
        articleIDs: [String]
    ) async throws -> [String: [String]] {
        guard !articleIDs.isEmpty else { return [:] }
        let values =
            articleIDs
            .map {
                "'\($0.replacingOccurrences(of: "'", with: "''"))'"
            }
            .joined(separator: ", ")
        return try await connection.run(
            query: #"""
                SELECT article_id, category_id
                FROM news_article_category
                WHERE article_id IN (\#(unescaped: values))
                ORDER BY article_id ASC, category_id ASC;
                """#
        ) { sequence in
            var result: [String: [String]] = [:]
            for row in try await sequence.collect() {
                let articleID = try row.decode(
                    column: "article_id",
                    as: String.self
                )
                let categoryID = try row.decode(
                    column: "category_id",
                    as: String.self
                )
                result[articleID, default: []].append(categoryID)
            }
            return result
        }
    }

    func replace(
        articleID: String,
        categoryIDs: [String]
    ) async throws {
        try await connection.run(
            query: #"""
                DELETE FROM news_article_category
                WHERE article_id = \#(articleID);
                """#
        ) { _ in }

        for categoryID in categoryIDs {
            try await connection.run(
                query: #"""
                    INSERT INTO news_article_category (
                        article_id,
                        category_id
                    ) VALUES (
                        \#(articleID),
                        \#(categoryID)
                    )
                    ON CONFLICT (article_id, category_id) DO NOTHING;
                    """#
            ) { _ in }
        }
    }

    func removeArticle(
        id: String
    ) async throws {
        try await connection.run(
            query: #"""
                DELETE FROM news_article_category
                WHERE article_id = \#(id);
                """#
        ) { _ in }
    }

    func removeCategory(
        id: String
    ) async throws {
        try await connection.run(
            query: #"""
                DELETE FROM news_article_category
                WHERE category_id = \#(id);
                """#
        ) { _ in }
    }
}
