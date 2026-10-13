import FeatherAdmin
import Hummingbird

protocol AdminViewUserOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminViewUserOverviewModel
}
