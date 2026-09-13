import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminViewRedirectOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminViewRedirectOverviewModel
}
