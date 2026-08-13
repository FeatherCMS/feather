import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveMediaProcessorPresenter: Sendable {

    func renderPage(
        model: AdminRemoveMediaProcessorModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
