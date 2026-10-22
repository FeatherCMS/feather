import AccountAdminAPI
import AccountModule

extension Invitation.List.Interactor {

    protocol Interface: Sendable {

        func execute(
            page: Int,
            size: Int,
            search: String?
        ) async throws -> (
            items: [Components.Schemas.InvitationQuerySchemasItem],
            total: Int,
            page: Int,
            size: Int
        )

    }
}
