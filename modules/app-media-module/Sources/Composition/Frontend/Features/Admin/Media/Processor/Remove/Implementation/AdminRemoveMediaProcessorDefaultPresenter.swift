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

    func renderRemovePage(
        model: AdminRemoveMediaProcessorModel
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove media processor",
            content: MediaProcessorRemoveView(
                item: model.item,
                nonceToken: nonceToken,
                cancelURL: "/admin/media/processors/",
                formURL: "/admin/media/processors/\(model.item.id)/remove/"
            )
        )
    }
}
