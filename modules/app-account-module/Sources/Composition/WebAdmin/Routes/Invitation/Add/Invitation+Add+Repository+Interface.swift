import AccountModule

extension Invitation.Add.Repository {

    protocol Interface: Sendable {

        func create(
            payload: Invitation.Form.Payload
        ) async throws
    }
}
