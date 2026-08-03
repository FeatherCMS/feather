import AdminOpenAPI

protocol AdminListAuthCredentialAccountInteractor: Sendable {
    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserAccountListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )
}
