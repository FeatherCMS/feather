import NewsAdminAPI

protocol AdminNewsCategoryRepository: Sendable {
    func list(
        page: Int,
        search: String?
    ) async throws
        -> AdminNewsCategoryListModel
    func get(
        id: String
    ) async throws
        -> Components.Schemas.NewsCategoryDetailSchema
    func create(
        input: Components.Schemas.NewsCategoryCreateSchema
    ) async throws
    func update(
        id: String,
        input: Components.Schemas.NewsCategoryCreateSchema
    ) async throws
    func remove(
        id: String
    ) async throws
}
