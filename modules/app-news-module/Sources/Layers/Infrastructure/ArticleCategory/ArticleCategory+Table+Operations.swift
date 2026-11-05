import FeatherDBAL
import FeatherInfrastructure
import NewsModule

extension ArticleCategory.Table {
    static func listCategoryIDs(
        context: any DatabaseAccessContext,
        articleID: String
    ) async throws -> [String] {
        try await DatabaseAccessLayer<Self>(context: context)
            .select {
                $0.where(\.articleId, equals: articleID)
                    .order(by: \.categoryId)
            }
            .map(\.categoryId)
    }

    static func listCategoryIDs(
        context: any DatabaseAccessContext,
        articleIDs: [String]
    ) async throws -> [String: [String]] {
        guard !articleIDs.isEmpty else { return [:] }
        let rows = try await DatabaseAccessLayer<Self>(context: context)
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

    static func replace(
        context: any DatabaseAccessContext,
        articleID: String,
        categoryIDs: [String]
    ) async throws {
        let accessLayer = DatabaseAccessLayer<Self>(context: context)
        try await accessLayer.delete(where: \.articleId, equals: articleID)
        try await accessLayer.insert(
            Set(categoryIDs)
                .map {
                    Insert(articleId: articleID, categoryId: $0)
                }
        )
    }

    static func removeCategory(
        context: any DatabaseAccessContext,
        id: String
    ) async throws {
        try await DatabaseAccessLayer<Self>(context: context)
            .delete(where: \.categoryId, equals: id)
    }
}
