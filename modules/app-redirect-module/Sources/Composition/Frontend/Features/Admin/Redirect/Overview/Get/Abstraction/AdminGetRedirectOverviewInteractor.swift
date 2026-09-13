import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminGetRedirectOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminGetRedirectOverviewModel
}
