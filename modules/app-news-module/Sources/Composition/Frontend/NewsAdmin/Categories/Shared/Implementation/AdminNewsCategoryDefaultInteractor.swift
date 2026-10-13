import NewsAdminAPI

struct AdminNewsCategoryDefaultInteractor: AdminNewsCategoryInteractor {
    let repository: any AdminNewsCategoryRepository

    func list(
        page: Int,
        search: String?
    ) async throws
        -> AdminNewsCategoryListModel
    {
        try await repository.list(page: page, search: search)
    }

    func get(
        id: String
    ) async throws
        -> Components.Schemas.NewsCategoryDetailSchema
    {
        try await repository.get(id: id)
    }

    func create(
        input: Components.Schemas.NewsCategoryCreateSchema
    ) async throws {
        try await repository.create(input: input)
    }

    func update(
        id: String,
        input: Components.Schemas.NewsCategoryCreateSchema
    ) async throws {
        try await repository.update(id: id, input: input)
    }

    func remove(
        id: String
    ) async throws {
        try await repository.remove(id: id)
    }
}
