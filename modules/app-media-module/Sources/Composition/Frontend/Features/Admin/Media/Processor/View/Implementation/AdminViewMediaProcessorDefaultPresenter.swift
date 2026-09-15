import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewMediaProcessorDefaultPresenter: AdminViewMediaProcessorPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderDetailsPage(
        model: AdminViewMediaProcessorModel?,
        id: String,
        permissions: NewAdminListActions,
        error: String?
    ) async throws -> HTMLResponse {
        if let model {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Media processor details",
                content: MediaProcessorDetailsView(
                    item: model.item,
                    permissions: permissions
                )
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Media processor details",
            content: MediaProcessorErrorView(
                info: error ?? "Processor not found."
            )
        )
    }
}
