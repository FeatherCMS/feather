import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Resend {
    enum Repository {}
}

extension Invitation.Resend.Repository {

    protocol Interface: Sendable {

        func resend(
            id: String
        ) async throws
    }
}
