import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditMediaAssetDefaultPresenter: AdminEditMediaAssetPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderEditPage(
        model: AdminEditMediaAssetModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit media asset",
            content: AssetEditView(
                state: .init(
                    model: model,
                    permissions: permissions
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit media asset",
            content: MediaAssetErrorView(
                info: info,
                message: message
            )
        )
    }

}
