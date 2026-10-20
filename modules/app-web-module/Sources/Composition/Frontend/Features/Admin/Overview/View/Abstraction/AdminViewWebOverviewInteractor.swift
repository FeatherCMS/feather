import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminViewWebOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminViewWebOverviewModel
}
