import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserWebAdmin

extension Invitation.Detail {
    enum Repository {}
}

extension Invitation.Detail.Repository {

    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> Invitation.Detail.Result
    }
}
