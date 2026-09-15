import FeatherAdmin
import Hummingbird

protocol AdminViewAccountOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminViewAccountOverviewModel
}
