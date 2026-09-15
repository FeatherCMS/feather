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

struct AdminRemoveAuthMagicLinkDefaultController:
    AdminRemoveAuthMagicLinkController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveAuthMagicLinkInteractor,
            presenter: any AdminRemoveAuthMagicLinkPresenter
        )

    func getRemoveAuthMagicLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        let permissions = context.currentUserPermissions
        guard
            context.isCurrentUserAllowed(to: AuthPermissions.MagicLinks.delete)
        else {
            return try await presenter.renderError(
                id: id,
                error: .forbidden,
                permissions: permissions
            )
        }
        do {
            let link = try await interactor.get(id: id)
            return try await presenter.renderPage(
                id: id,
                credentialId: link.credentialId,
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

    func postRemoveAuthMagicLink(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredID()
        guard
            context.isCurrentUserAllowed(to: AuthPermissions.MagicLinks.delete)
        else {
            return
                try await presenter.renderError(
                    id: id,
                    error: .forbidden,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
        let nonceRequest = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else {
            return try await presenter.renderInvalidNoncePage()
                .response(from: request, context: context)
        }
        do {
            try await interactor.execute(
                entity: .init(id: id)
            )
            return AdminNotificationFlash.redirect(
                to: "/admin/auth/magic-links/",
                notification: .init(
                    title: "Removed",
                    message: "User magic link removed successfully."
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return
                try await presenter.renderError(
                    id: id,
                    error: error,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
