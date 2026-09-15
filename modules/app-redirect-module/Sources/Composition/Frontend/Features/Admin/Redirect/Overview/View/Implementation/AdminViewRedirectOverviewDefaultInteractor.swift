import FeatherAdmin
import Foundation
import Hummingbird

struct AdminViewRedirectOverviewDefaultInteractor:
    AdminViewRedirectOverviewInteractor
{
    func getOverview() async throws -> AdminViewRedirectOverviewModel {
        .init(title: "Redirect module")
    }
}
