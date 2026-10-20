import FeatherWebAdmin

protocol AdminViewNewsletterOverviewInteractor: Sendable {
    func getOverview() async throws -> AdminViewNewsletterOverviewModel
}
