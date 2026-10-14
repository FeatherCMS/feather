import AccountAdminAPI

struct AdminListAccountInvitationDefaultInteractor:
    AdminListAccountInvitationInteractor
{
    let repository: any AdminListAccountInvitationRepository

    func execute(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.AccountInvitationListItemSchema], total: Int,
        page: Int, size: Int
    ) {
        try await repository.list(
            page: page,
            size: size,
            search: search
        )
    }

}
