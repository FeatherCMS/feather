extension Overview {
    enum Interactor {}
}

extension Overview.Interactor {
    protocol Interface: Sendable {
        func execute() async throws -> Overview.Model
    }
}
