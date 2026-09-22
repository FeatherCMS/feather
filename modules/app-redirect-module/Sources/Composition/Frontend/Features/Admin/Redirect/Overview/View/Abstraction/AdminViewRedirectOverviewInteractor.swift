import FeatherAdmin
import Hummingbird

protocol AdminViewRedirectOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminViewRedirectOverviewModel
}
