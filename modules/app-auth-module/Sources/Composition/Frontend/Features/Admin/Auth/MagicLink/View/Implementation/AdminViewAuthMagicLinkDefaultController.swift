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

struct AdminViewAuthMagicLinkDefaultController: AdminViewAuthMagicLinkController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewAuthMagicLinkInteractor,
            presenter: any AdminViewAuthMagicLinkPresenter
        )

    func getAuthMagicLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime(
            request,
            context
        )
        let permissions = context.currentUserPermissions
        guard context.isCurrentUserAllowed(to: AuthPermissions.MagicLinks.read)
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
