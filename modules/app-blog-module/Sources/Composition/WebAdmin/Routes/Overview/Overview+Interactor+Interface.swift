extension Overview.Interactor {
    protocol Interface: Sendable {
        func execute() async throws -> Overview.Model
    }
}
