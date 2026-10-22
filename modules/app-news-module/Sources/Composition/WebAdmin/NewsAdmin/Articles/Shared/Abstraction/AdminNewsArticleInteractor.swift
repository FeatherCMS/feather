import NewsAdminAPI

protocol AdminNewsArticleInteractor: Sendable {
    func list(
        page: Int,
        search: String?
    ) async throws
        -> AdminNewsArticleListModel
    func get(
        id: String
    ) async throws
        -> Components.Schemas.NewsArticleDetailSchema
    func categories() async throws -> [AdminNewsArticleCategoryOption]
    func create(
        input: Components.Schemas.NewsArticleCreateSchema
    ) async throws
    func update(
        id: String,
        input: Components.Schemas.NewsArticleCreateSchema
    ) async throws
    func remove(
        id: String
    ) async throws
}
