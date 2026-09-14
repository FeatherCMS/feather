import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebOverviewDefaultInteractor: AdminViewWebOverviewInteractor {
    func getOverview() async throws -> AdminViewWebOverviewModel {
        .init(title: "Web module")
    }
}
