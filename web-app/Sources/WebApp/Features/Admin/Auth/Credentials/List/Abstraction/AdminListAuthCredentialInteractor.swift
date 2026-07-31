import AdminOpenAPI

protocol AdminListAuthCredentialInteractor: Sendable {
    func execute(
        accountID: String,
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserCredentialListItemSchema],
        total: Int,
        page: Int,
        size: Int
    )
}
