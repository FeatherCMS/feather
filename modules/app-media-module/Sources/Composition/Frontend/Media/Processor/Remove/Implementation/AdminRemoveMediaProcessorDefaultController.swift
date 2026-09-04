import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminRemoveMediaProcessorDefaultController:
    AdminRemoveMediaProcessorController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveMediaProcessorInteractor,
            presenter: any AdminRemoveMediaProcessorPresenter
        )

    func getRemoveMediaProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        let model = try await interactor.getRemoveMediaProcessor(id: id)
        return presenter.renderPage(
            model: model,
            permissions: permissions
        )
    }

    func postRemoveMediaProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        let model = try await interactor.postRemoveMediaProcessor(id: id)
        if model.error == nil {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/media/processors/",
                        title: "Removed",
                        message: "Processor removed successfully."
                    )
                ]
            )
        }
        return
            try presenter.renderPage(
                model: model,
                permissions: permissions
            )
            .response(from: request, context: context)
    }
}
