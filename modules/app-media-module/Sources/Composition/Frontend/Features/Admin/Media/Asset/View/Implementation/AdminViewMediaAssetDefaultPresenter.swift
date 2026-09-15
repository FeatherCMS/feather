import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewMediaAssetDefaultPresenter: AdminViewMediaAssetPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderDetailsPage(
        model: AdminViewMediaAssetModel?,
        id: String,
        permissions: NewAdminListActions,
        error: String?
    ) async throws -> HTMLResponse {
        if let model {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Media asset details",
                content: AssetDetailsView(
                    item: model.item,
                    variants: model.variants,
                    permissions: permissions
                )
            )
        }
        return try await renderEngine.renderNewAdminPage(
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
