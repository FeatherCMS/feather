extension Overview.View {
    enum Interactor {}
}

extension Overview.View.Interactor {
    protocol Interface: Sendable {
        func getOverview() async throws -> Overview.View.Model
    }
}
