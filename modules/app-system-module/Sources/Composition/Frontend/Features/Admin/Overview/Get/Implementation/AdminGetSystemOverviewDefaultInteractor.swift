import FeatherAdmin
import Hummingbird

struct AdminGetSystemOverviewDefaultInteractor: AdminGetSystemOverviewInteractor {
    func getHome() async throws -> AdminGetSystemOverviewModel {
        .init(title: "System module")
    }
}
