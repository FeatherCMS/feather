extension Login.Interactor {
    protocol Interface: Sendable {

        func execute(
            entity: Login.Model
        ) async throws -> Login.Result
    }
}
