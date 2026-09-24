import AuthAdminAPI
import AuthAppAPI
import AuthContracts
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AdminViewAuthEmailDefaultController: AdminViewAuthEmailController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewAuthEmailInteractor,
            any AdminViewAuthEmailPresenter
        >

    func getAuthEmail(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let id = try request.requiredID()
        let (interactor, presenter) = buildRuntime((request, context))
        let permissions = context.currentUserPermissions
        guard context.isCurrentUserAllowed(to: AuthPermissions.Emails.read)
        else {
            return try await presenter.renderError(
                id: id,
                error: .forbidden,
                permissions: permissions
            )
        }
        do {
            let link = try await interactor.execute(
                entity: .init(id: id)
            )
            return try await presenter.renderPage(
                link: link,
                permissions: permissions
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderError(
                id: id,
                error: error,
                permissions: permissions
            )
        }
    }
}
