import UserModule

extension Identity.Add {
    enum Repository {}
}

extension Identity.Add.Repository {
    protocol Interface: Sendable {

        func create(
            payload: Identity.Add.FormPayload
        ) async throws
    }
}
