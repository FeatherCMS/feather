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

struct AdminViewMediaProcessorDefaultController:
    AdminViewMediaProcessorController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewMediaProcessorInteractor,
            presenter: any AdminViewMediaProcessorPresenter
        )

    func getMediaProcessor(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserAdminListActions
        do {
            let model = try await interactor.getMediaProcessor(id: id)
            return try await presenter.renderDetailsPage(
                model: model,
                id: id,
                permissions: permissions,
                error: nil
            )
        }
        catch {
            return try await presenter.renderDetailsPage(
                model: nil,
                id: id,
                permissions: permissions,
                error: error.displayMessage
            )
        }
    }
}
