import FeatherWebAdmin
import FeatherModuleKit
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminViewMediaAssetPresenter: Sendable {

    func renderDetailsPage(
        model: AdminViewMediaAssetModel?,
        id: String,
        permissions: AdminListActions,
        error: String?
    ) async throws -> HTMLResponse
}
