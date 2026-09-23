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

struct AdminRemoveAuthEmailDefaultController:
    AdminRemoveAuthEmailController
{
    let buildRuntime: RuntimeBuilder<
        any AdminRemoveAuthEmailInteractor,
        any AdminRemoveAuthEmailPresenter
    >

    func getRemoveAuthEmail(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let id = try context.requiredID()
        guard context.isCurrentUserAllowed(to: AuthPermissions.Emails.delete)
        else {
            return try await presenter.renderError(
                item: .init(id: id, label: id),
                error: .forbidden
            )
        }
        do {
            let link = try await interactor.get(id: id)
            return try await presenter.renderPage(
                item: .init(id: id, label: link.identityId),
                identityId: link.identityId,
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderError(
                item: .init(id: id, label: id),
                error: error
            )
        }
    }

    func postRemoveAuthEmail(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        let id = try context.requiredID()
        guard context.isCurrentUserAllowed(to: AuthPermissions.Emails.delete)
        else {
            return
                try await presenter.renderError(
                    item: .init(id: id, label: id),
                    error: .forbidden
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
                to: "/admin/auth/emails/",
                notification: .init(
                    title: "Removed",
                    message: "User email removed successfully."
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return
                try await presenter.renderError(
                    item: .init(id: id, label: id),
                    error: error
                )
                .response(from: request, context: context)
        }
    }
}
