struct AdminViewAccountOverviewDefaultInteractor:
    AdminViewAccountOverviewInteractor
{
    func getOverview() async throws -> AdminViewAccountOverviewModel {
        .init(title: "Account module")
    }
}
