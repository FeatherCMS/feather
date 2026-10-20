import FeatherWebAdmin
import FeatherModuleKit
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditMediaFolderDefaultPresenter: AdminEditMediaFolderPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderEditPage(
        model: AdminEditMediaFolderModel,
        permissions: AdminListActions
    ) async throws -> HTMLResponse {
        try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Edit media folder",
            content: MediaFolderEditView(
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
        permissions: AdminListActions
    ) async throws -> HTMLResponse {
        try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Edit media folder",
            content: MediaAssetErrorView(
                info: info,
                message: message
            )
        )
    }

}
