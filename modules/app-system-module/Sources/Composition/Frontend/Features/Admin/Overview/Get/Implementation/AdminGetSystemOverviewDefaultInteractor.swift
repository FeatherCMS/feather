import FeatherAdmin
import Hummingbird

struct AdminGetSystemOverviewDefaultInteractor: AdminGetSystemOverviewInteractor
{
    func getOverview() async throws -> AdminGetSystemOverviewModel {
        .init(title: "System module")
    }
}
