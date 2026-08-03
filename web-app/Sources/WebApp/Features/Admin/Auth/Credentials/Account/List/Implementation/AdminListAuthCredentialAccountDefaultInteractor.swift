import AdminOpenAPI

struct AdminListAuthCredentialAccountDefaultInteractor:
    AdminListAuthCredentialAccountInteractor
{
    let repository: any AdminListAuthCredentialAccountRepository

    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserAccountListItemSchema],
        total: Int,
        page: Int,
        size: Int
    ) {
        try await repository.list(page: page, size: size, search: search)
    }
}
