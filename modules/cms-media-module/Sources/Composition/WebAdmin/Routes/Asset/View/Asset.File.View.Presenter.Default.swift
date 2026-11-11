import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.View.Presenter {
    struct Default: Interface {
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
                let preservedQueryItems = [
                    "parent_id",
                    "view",
                    "picker",
                    "field",
                    "extensions",
                    "default_folder_path",
                    "preview_variant",
                ].compactMap { name in
                    request.uri.queryParameters[name[...]].map {
                        URLQueryItem(name: name, value: String($0))
                    }
                }
                let detailsPath = AdminLocation.url(
                    path: routes.file.detailsPath(id),
                    queryItems: preservedQueryItems
                )
                let variantsPath = AdminLocation.url(
                    path: routes.file.detailsPath(id),
                    queryItems: preservedQueryItems + [
                        .init(name: "tab", value: "variants")
                    ]
                )
                let activeTab = Asset.File.View.TabBar.Tab(
                    rawValue: request.uri.queryParameters["tab"]
                        .map(String.init) ?? ""
                ) ?? .details
                return try await renderEngine.renderAdminPage(
                    request: request,
                    context: context,
                    title: "Media asset details",
                    content: Asset.File.View.Page(
                        item: model.item,
                        variants: model.variants,
                        permissions: permissions,
                        routes: routes,
                        activeTab: activeTab,
                        detailsPath: detailsPath,
                        variantsPath: variantsPath
                    )
                )
            }
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Media asset details",
                content: Asset.Error.Page(
                    info: "Asset not found.",
                    message: error ?? "Unknown error"
                )
            )
        }

    }
}
