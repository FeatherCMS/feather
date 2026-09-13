import FeatherAdmin
import Hummingbird

struct AdminViewSystemOverviewDefaultInteractor:
    AdminViewSystemOverviewInteractor
{
    func getOverview() async throws -> AdminViewSystemOverviewModel {
        .init(title: "System module")
    }
}
