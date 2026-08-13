import FeatherDatabase

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
