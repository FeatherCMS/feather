import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Remove {
    enum Repository {}
}

extension Invitation.Remove.Repository {

    protocol Interface: Sendable {

        func get(
            id: String
        ) async throws -> Invitation.Detail.Result

        func delete(
            id: String
        ) async throws
    }
}
