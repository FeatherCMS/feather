import UserModule



extension Identity.Edit {
    enum Repository {}
}

extension Identity.Edit.Repository {
    protocol Interface: Sendable {

        func load(
            id: String
        ) async throws -> Identity.Edit.Model

        func update(
            id: String,
            payload: Identity.Edit.FormPayload
        ) async throws
    }
}
