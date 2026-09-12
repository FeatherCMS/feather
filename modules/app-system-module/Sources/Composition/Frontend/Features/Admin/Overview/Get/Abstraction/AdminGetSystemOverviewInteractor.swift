import FeatherAdmin
import Hummingbird

protocol AdminGetSystemOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminGetSystemOverviewModel
}
