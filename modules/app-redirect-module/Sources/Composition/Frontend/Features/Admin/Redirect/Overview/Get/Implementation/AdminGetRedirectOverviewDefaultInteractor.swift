import FeatherAdmin
import Foundation
import Hummingbird

struct AdminGetRedirectOverviewDefaultInteractor: AdminGetRedirectOverviewInteractor {
    func getOverview() async throws -> AdminGetRedirectOverviewModel {
        .init(title: "Redirect module")
    }
}
