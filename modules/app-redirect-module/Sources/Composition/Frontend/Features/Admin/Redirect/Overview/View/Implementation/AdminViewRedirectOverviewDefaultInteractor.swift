import FeatherAdmin
import Hummingbird

struct AdminViewRedirectOverviewDefaultInteractor:
    AdminViewRedirectOverviewInteractor
{
    func getOverview() async throws -> AdminViewRedirectOverviewModel {
        .init(title: "Redirect module")
    }
}
