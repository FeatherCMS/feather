import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewMediaOverviewDefaultInteractor: AdminViewMediaOverviewInteractor
{
    func getOverview() async throws -> AdminViewMediaOverviewModel {
        .init(title: "Media management")
    }
}
