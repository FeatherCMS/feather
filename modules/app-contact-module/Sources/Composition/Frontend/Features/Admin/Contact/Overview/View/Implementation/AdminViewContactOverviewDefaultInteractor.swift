struct AdminViewContactOverviewDefaultInteractor:
    AdminViewContactOverviewInteractor
{
    func getOverview() async throws -> AdminViewContactOverviewModel {
        .init(title: "Contact module")
    }
}
