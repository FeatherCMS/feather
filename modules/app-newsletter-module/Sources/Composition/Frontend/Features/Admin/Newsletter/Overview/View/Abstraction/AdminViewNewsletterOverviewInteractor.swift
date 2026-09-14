import FeatherAdmin

protocol AdminViewNewsletterOverviewInteractor: Sendable {
    func getOverview() async throws -> AdminViewNewsletterOverviewModel
}
