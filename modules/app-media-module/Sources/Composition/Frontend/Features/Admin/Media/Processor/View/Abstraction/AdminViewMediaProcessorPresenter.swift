import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminViewMediaProcessorPresenter: Sendable {

    func renderDetailsPage(
        model: AdminViewMediaProcessorModel?,
        id: String,
        permissions: NewAdminListActions,
        error: String?
    ) async throws -> HTMLResponse
}
