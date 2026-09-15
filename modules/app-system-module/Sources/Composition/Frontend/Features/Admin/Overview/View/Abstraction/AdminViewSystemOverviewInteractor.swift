import FeatherAdmin
import Hummingbird

protocol AdminViewSystemOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminViewSystemOverviewModel
}
