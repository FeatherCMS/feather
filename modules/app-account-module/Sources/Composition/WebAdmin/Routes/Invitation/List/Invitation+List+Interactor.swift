import AccountAdminAPI
import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.List {
    enum Interactor {}
}

extension Invitation.List.Interactor {

    protocol Interface: Sendable {

        func execute(
            page: Int,
            size: Int,
            search: String?
        ) async throws -> Invitation.List.Result

    }
}
