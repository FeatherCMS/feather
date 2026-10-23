import AccountAdminAPI
import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.List {
    enum Repository {}
}

extension Invitation.List.Repository {

    protocol Interface: Sendable {

        func list(
            page: Int,
            size: Int,
            search: String?
        ) async throws -> Invitation.List.Result

    }
}
