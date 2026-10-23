import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension MagicLink.View.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any MagicLink.View.Interactor.Interface,
                any MagicLink.View.Presenter.Interface
            >

        func getAuthMagicLink(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let id = try context.requiredID()
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let permissions = context.currentUserPermissions
            guard
                context.isCurrentUserAllowed(
                    to: MagicLink.Permissions.read
                )
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
}
