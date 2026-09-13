import FeatherAdmin
import Hummingbird

protocol AdminGetUserOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminGetUserOverviewModel
}
