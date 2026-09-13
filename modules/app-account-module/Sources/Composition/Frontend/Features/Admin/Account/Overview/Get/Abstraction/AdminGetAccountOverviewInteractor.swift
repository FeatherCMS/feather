import FeatherAdmin
import Hummingbird

protocol AdminGetAccountOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminGetAccountOverviewModel
}
