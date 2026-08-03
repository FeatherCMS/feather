import AdminOpenAPI

protocol AdminListAuthCredentialAccountRepository: Sendable {
    func list(
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
