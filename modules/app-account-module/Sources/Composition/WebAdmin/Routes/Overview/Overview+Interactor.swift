extension Overview.Interactor {

    protocol Interface: Sendable {

        func getOverview() async throws -> Overview.Model
    }
}
