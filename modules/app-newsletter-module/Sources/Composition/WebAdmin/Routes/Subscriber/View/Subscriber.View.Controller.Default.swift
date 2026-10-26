import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Subscriber.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Subscriber.View.Interactor.Interface,
                any Subscriber.View.Presenter.Interface
            >

        func view(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            guard context.isCurrentUserAllowed(to: Subscriber.Permissions.read)
            else {
                return try await runtime.presenter.renderErrorPage(
                    message: "Your account cannot view newsletter subscribers.",
                    status: .forbidden
                )
            }
            do {
                return try await runtime.presenter.render(
                    model: try await runtime.interactor.get(
                        id: try context.requiredParameter("subscriberId")
                    ),
                    permissions: context.currentUserPermissions
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await runtime.presenter.renderErrorPage(
                    message: error.displayMessage,
                    status: error.httpStatus
                )
            }
            catch {
                return try await runtime.presenter.renderErrorPage(
                    message: error.displayMessage,
                    status: .internalServerError
                )
            }
        }
    }
}
