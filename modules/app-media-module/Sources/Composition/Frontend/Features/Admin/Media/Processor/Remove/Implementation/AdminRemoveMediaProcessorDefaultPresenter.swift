import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveMediaProcessorDefaultPresenter:
    AdminRemoveMediaProcessorPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminRemoveMediaProcessorModel
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove media processor",
            content: MediaProcessorRemoveView(
                id: model.id,
                cancelURL: "/admin/media/processors/",
                formURL: "/admin/media/processors/\(model.id)/remove/"
            )
        )
    }
}
