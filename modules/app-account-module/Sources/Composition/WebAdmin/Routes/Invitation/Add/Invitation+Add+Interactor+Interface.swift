import AccountModule

extension Invitation.Add.Interactor {

    protocol Interface: Sendable {

        func execute(
            entity: Invitation.Add.Model
        ) async throws
    }
}
