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

extension Asset.File.View.Presenter {
    struct Default: Asset.File.View.Presenter.Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Asset.Router.Routes

        func renderDetailsPage(
            model: Asset.File.View.Model?,
            id: String,
            permissions: AdminListActions,
            error: String?
        ) async throws -> HTMLResponse {
            if let model {
                return try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "Media asset details",
                    content: AssetDetailsView(
                        item: model.item,
                        variants: model.variants,
                        permissions: permissions,
                        routes: routes
                    )
                )
            }
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Media asset details",
                content: MediaAssetErrorView(
                    info: "Asset not found.",
                    message: error ?? "Unknown error"
                )
            )
        }

    }
}
