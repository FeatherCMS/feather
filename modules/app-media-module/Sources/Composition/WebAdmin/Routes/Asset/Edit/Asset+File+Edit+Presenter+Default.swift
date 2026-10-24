import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Asset.Router.Routes

        func renderEditPage(
            model: Asset.File.Edit.Model,
            permissions: AdminListActions
        ) async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit media asset",
                content: Asset.File.Edit.Page(
                    state: .init(
                        model: model,
                        permissions: permissions,
                        routes: routes
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
                title: "Edit media asset",
                content: Asset.Error.Page(
                    info: info,
                    message: message
                )
            )
        }

    }
}
