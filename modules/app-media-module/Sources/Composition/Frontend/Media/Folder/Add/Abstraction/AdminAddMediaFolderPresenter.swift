import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddMediaFolderPresenter: Sendable {
    func renderPage(
        model: AdminAddMediaFolderModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
