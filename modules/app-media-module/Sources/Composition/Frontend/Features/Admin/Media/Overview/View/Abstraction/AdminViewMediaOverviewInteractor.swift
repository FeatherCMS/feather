import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminViewMediaOverviewInteractor: Sendable {

    func getOverview() async throws -> AdminViewMediaOverviewModel
}
