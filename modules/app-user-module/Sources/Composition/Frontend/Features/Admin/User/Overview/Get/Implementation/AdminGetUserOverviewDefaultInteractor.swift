import FeatherAdmin
import Hummingbird

struct AdminGetUserOverviewDefaultInteractor: AdminGetUserOverviewInteractor {
    func getOverview() async throws -> AdminGetUserOverviewModel {
        .init(title: "User module")
    }
}
