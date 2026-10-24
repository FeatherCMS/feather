import FeatherDBAL
import NewsModule

struct ArticleCategoryTable {
    let context: any DatabaseAccessContext

    func listCategoryIDs(
        articleID: String
    ) async throws -> [String] {
        try await DatabaseAccessLayer<Article.CategoryTable>(context: context)
            .select {
                $0.where(\.articleId, equals: articleID)
                    .order(by: \.categoryId)
            }
            .map(\.categoryId)
    }

    func listCategoryIDs(
        articleIDs: [String]
    ) async throws -> [String: [String]] {
        guard !articleIDs.isEmpty else { return [:] }
        let rows = try await DatabaseAccessLayer<Article.CategoryTable>(context: context)
            .select {
                $0.where(\.articleId, in: articleIDs)
                    .order(by: \.articleId)
                    .order(by: \.categoryId)
            }
        var result: [String: [String]] = [:]
        for row in rows {
            result[row.articleId, default: []].append(row.categoryId)
        }
        return result
    }

    func replace(
        articleID: String,
        categoryIDs: [String]
    ) async throws {
        let accessLayer = DatabaseAccessLayer<Article.CategoryTable>(context: context)
        try await accessLayer.delete(where: \.articleId, equals: articleID)
        try await accessLayer.insert(
            Set(categoryIDs).map {
                Article.CategoryTable.Insert(articleId: articleID, categoryId: $0)
            }
        )
    }

    func removeArticle(
        id: String
    ) async throws {
        try await DatabaseAccessLayer<Article.CategoryTable>(context: context)
            .delete(where: \.articleId, equals: id)
    }

    func removeCategory(
        id: String
    ) async throws {
        try await DatabaseAccessLayer<Article.CategoryTable>(context: context)
            .delete(where: \.categoryId, equals: id)
    }
}
