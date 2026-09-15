import FeatherAdmin
import Hummingbird

protocol AdminViewAnalyticsOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminViewAnalyticsOverviewModel
}
