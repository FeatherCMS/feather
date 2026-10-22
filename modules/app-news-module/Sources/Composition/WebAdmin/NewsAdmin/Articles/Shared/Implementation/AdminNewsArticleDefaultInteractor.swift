import NewsAdminAPI

struct AdminNewsArticleDefaultInteractor: AdminNewsArticleInteractor {
    let repository: any AdminNewsArticleRepository

    func list(
        page: Int,
        search: String?
    ) async throws
        -> AdminNewsArticleListModel
    {
        try await repository.list(page: page, search: search)
    }

    func get(
        id: String
    ) async throws
        -> Components.Schemas.NewsArticleDetailSchema
    {
        try await repository.get(id: id)
    }

    func categories() async throws -> [AdminNewsArticleCategoryOption] {
        try await repository.categories()
    }

    func create(
        input: Components.Schemas.NewsArticleCreateSchema
    ) async throws {
        try await repository.create(input: input)
    }

    func update(
        id: String,
        input: Components.Schemas.NewsArticleCreateSchema
    ) async throws {
        try await repository.update(id: id, input: input)
    }

    func remove(
        id: String
    ) async throws {
        try await repository.remove(id: id)
    }
}
