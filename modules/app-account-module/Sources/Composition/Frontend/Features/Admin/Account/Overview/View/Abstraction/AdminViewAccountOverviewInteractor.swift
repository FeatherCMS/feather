protocol AdminViewAccountOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminViewAccountOverviewModel
}
