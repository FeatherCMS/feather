import FeatherAdmin

struct AdminViewNewsletterOverviewDefaultInteractor:
    AdminViewNewsletterOverviewInteractor
{
    func getOverview() async throws -> AdminViewNewsletterOverviewModel {
        .init(title: "Newsletter module")
    }
}
