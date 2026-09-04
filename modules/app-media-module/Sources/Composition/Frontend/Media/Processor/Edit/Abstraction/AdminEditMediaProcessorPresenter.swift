import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditMediaProcessorPresenter: Sendable {

    func renderPage(
        model: AdminEditMediaProcessorModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
