import UserModule



extension Identity.Add.Repository {
    protocol Interface: Sendable {

        func create(
            payload: Identity.Add.FormPayload
        ) async throws
    }
}
