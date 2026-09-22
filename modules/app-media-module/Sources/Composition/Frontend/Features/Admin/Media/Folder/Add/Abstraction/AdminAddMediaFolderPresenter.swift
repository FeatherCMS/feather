import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddMediaFolderPresenter: Sendable {
    func renderPage(
        model: AdminAddMediaFolderModel
    ) async throws -> HTMLResponse
}
