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

struct AdminEditMediaProcessorDefaultPresenter: AdminEditMediaProcessorPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminEditMediaProcessorModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit media processor",
            content: MediaProcessorFormView(
                title: "Edit processor",
                submitLabel: "Save",
                actionURL: "/admin/media/processors/\(model.id)/edit/",
                form: .init(
                    fileSuffix: model.fileSuffix,
                    matchExtensions: model.matchExtensions,
                    commandTemplate: model.commandTemplate,
                    error: model.error
                ),
                permissions: permissions,
                requiredPermission: MediaPermissions.Processors.update,
                removeHref: permissions.allows(
                    MediaPermissions.Processors.delete
                )
                    ? NewAdminLocation.remove(
                        path: MediaProcessorRoutes.remove.description,
                        ids: [model.id],
                        returnTo:
                            MediaProcessorRoutes.edit(
                                RouterPath(model.id)
                            )
                            .description
                    ) : nil
            )
        )
    }
}
