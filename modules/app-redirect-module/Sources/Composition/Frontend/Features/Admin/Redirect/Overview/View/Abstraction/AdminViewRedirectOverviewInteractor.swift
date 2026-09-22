protocol AdminViewRedirectOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminViewRedirectOverviewModel
}
