import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminGetMediaProcessorPresenter: Sendable {

    func renderPage(
        model: AdminGetMediaProcessorModel?,
        id: String,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse
}
