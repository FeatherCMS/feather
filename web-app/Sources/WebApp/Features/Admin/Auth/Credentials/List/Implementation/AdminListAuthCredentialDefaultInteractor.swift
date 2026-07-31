import AdminOpenAPI

struct AdminListAuthCredentialDefaultInteractor: AdminListAuthCredentialInteractor {
    let repository: any AdminListAuthCredentialRepository

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
    ) {
        try await repository.list(
            accountID: accountID,
            page: page,
            size: size,
            search: search
        )
    }
}
