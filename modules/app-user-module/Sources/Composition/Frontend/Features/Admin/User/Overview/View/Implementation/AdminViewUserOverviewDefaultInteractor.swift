import FeatherAdmin
import Hummingbird

struct AdminViewUserOverviewDefaultInteractor: AdminViewUserOverviewInteractor {
    func getOverview() async throws -> AdminViewUserOverviewModel {
        .init(title: "User module")
    }
}
