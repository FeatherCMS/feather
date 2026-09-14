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

protocol AdminViewMediaOverviewPresenter: Sendable {

    func renderOverview(
        model: AdminViewMediaOverviewModel
    ) async throws -> HTMLResponse
}
