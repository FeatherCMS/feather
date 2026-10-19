import FeatherAdmin
import FeatherModuleKit
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditMediaAssetPresenter: Sendable {
    func renderEditPage(
        model: AdminEditMediaAssetModel,
        permissions: AdminListActions
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: AdminListActions
    ) async throws -> HTMLResponse
}
