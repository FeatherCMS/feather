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

struct AdminAddMediaProcessorDefaultPresenter:
    AdminAddMediaProcessorPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminAddMediaProcessorModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add media processor",
            content: MediaProcessorFormView(
                title: "Add processor",
                submitLabel: "Add",
                actionURL: "/admin/media/processors/add/",
                form: .init(
                    fileSuffix: model.fileSuffix,
                    matchExtensions: model.matchExtensions,
                    commandTemplate: model.commandTemplate,
                    error: model.error
                ),
                permissions: permissions,
                requiredPermission: MediaPermissions.Processors.create,
                removeHref: nil
            )
        )
    }
}
