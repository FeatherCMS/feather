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

struct AdminEditMediaProcessorDefaultController:
    AdminEditMediaProcessorController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditMediaProcessorInteractor,
            presenter: any AdminEditMediaProcessorPresenter
        )

    func getEditMediaProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserAdminListActions
        do {
            let model = try await interactor.getEditMediaProcessor(id: id)
            return try await presenter.renderPage(
                model: model,
                permissions: permissions
            )
        }
        catch {
            return try await presenter.renderPage(
                model: .init(
                    id: id,
                    fileSuffix: "",
                    matchExtensions: "",
                    commandTemplate: "",
                    error: error.displayMessage
                ),
                permissions: permissions
            )
        }
    }

    func postEditMediaProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserAdminListActions
        let payload = try await request.decode(
            as: AddProcessorForm.self,
            context: context
        )
        let model = try await interactor.postEditMediaProcessor(
            id: id,
            payload: payload
        )
        if model.error == nil {
            return AdminNotificationFlash.redirect(
                to: MediaProcessorRoutes.list.description,
                notification: .init(
                    title: "Saved",
                    message: "Media processor edited successfully."
                )
            )
        }
        return
            try await presenter.renderPage(
                model: model,
                permissions: permissions
            )
            .response(from: request, context: context)
    }
}
