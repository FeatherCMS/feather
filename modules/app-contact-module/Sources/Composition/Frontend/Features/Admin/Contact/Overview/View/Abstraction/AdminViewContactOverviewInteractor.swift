protocol AdminViewContactOverviewInteractor: Sendable {
    func getOverview() async throws -> AdminViewContactOverviewModel
}
