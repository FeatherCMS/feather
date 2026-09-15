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

struct AdminAddMediaProcessorDefaultController:
    AdminAddMediaProcessorController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminAddMediaProcessorInteractor,
            presenter: any AdminAddMediaProcessorPresenter
        )

    func getAddMediaProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        return try await presenter.renderPage(
            model: try await interactor.getAddMediaProcessor(),
            permissions: context.currentUserAdminListActions
        )
    }

    func postAddMediaProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: AddProcessorForm.self,
            context: context
        )
        let model = try await interactor.postAddMediaProcessor(
            payload: payload
        )
        if model.error == nil {
            return AdminNotificationFlash.redirect(
                to: MediaProcessorRoutes.list.description,
                notification: .init(
                    title: "Added",
                    message: "Media processor added successfully."
                )
            )
        }
        return
            try await presenter.renderPage(
                model: model,
                permissions: context.currentUserAdminListActions
            )
            .response(from: request, context: context)
    }
}
