import AccountAdminAPI
import AccountModule

extension Invitation.List.Repository {

    protocol Interface: Sendable {

        func list(
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
