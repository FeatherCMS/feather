import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Add {
    enum Repository {}
}

extension Invitation.Add.Repository {

    protocol Interface: Sendable {

        func create(
            payload: Invitation.Form.Payload
        ) async throws
    }
}
