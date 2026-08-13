import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminGetMediaHomePresenter: Sendable {

    func renderPage(
        model: AdminGetMediaHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
