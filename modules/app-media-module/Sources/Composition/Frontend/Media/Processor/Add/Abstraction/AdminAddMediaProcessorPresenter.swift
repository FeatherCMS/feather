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

protocol AdminAddMediaProcessorPresenter: Sendable {
    func renderPage(
        model: AdminAddMediaProcessorModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
