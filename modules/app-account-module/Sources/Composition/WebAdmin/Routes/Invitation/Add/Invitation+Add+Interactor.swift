import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Add {
    enum Interactor {}
}

extension Invitation.Add.Interactor {

    protocol Interface: Sendable {

        func execute(
            entity: Invitation.Add.Model
        ) async throws
    }
}
