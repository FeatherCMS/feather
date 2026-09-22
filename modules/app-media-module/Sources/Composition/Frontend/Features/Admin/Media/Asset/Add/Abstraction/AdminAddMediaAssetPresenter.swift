import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddMediaAssetPresenter: Sendable {
    func renderPage(
        model: AdminAddMediaAssetModel
    ) async throws -> HTMLResponse
}
