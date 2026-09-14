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
        let model = try await interactor.getRemoveMediaProcessor(id: id)
        return try await presenter.renderPage(
            model: model
        )
    }

    func postRemoveMediaProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let model = try await interactor.postRemoveMediaProcessor(id: id)
        if model.error == nil {
            return AdminNotificationFlash.redirect(
                to: MediaProcessorRoutes.list.description,
                notification: .init(
                    title: "Removed",
                    message: "Media processor removed successfully."
                )
            )
        }
        return
            try await presenter.renderPage(
                model: model
            )
            .response(from: request, context: context)
    }
}
