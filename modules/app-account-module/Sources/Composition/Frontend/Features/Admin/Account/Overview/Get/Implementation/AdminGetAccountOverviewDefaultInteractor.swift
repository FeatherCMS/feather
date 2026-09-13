import FeatherAdmin
import Hummingbird

struct AdminGetAccountOverviewDefaultInteractor:
    AdminGetAccountOverviewInteractor
{
    func getOverview() async throws -> AdminGetAccountOverviewModel {
        .init(title: "Account module")
    }
}
