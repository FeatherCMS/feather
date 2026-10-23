import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserWebAdmin

extension Invitation.Detail {
    enum Interactor {}
}

extension Invitation.Detail.Interactor {

    protocol Interface: Sendable {
        func roleNames(for ids: [String]) async -> [String]

        func execute(
            entity: Invitation.Detail.Model
        ) async throws -> AccountInvitationDetailsModel
    }
}
