import AuthAdminAPI
import AuthAppAPI
import AuthContracts
import CSS
import FeatherAdmin
import FeatherContracts
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

struct AdminRemoveAuthCredentialDefaultController:
    AdminRemoveAuthCredentialController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveAuthCredentialInteractor,
            any AdminRemoveAuthCredentialPresenter
        >

    func getRemoveCredential(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: AuthPermissions.Credential.delete)
        else {
            return try await presenter.renderError(
                item: .init(id: id, label: id),
                error: .forbidden
            )
        }
        do {
            let model = try await interactor.get(id: id)
            return try await presenter.renderPage(
                item: .init(
                    id: id,
                    label: model.email.emptyToNil ?? model.userId
                ),
                model: model
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await presenter.renderError(
                item: .init(id: id, label: id),
                error: error
            )
        }
    }

    func postRemoveCredential(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
    {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(to: AuthPermissions.Credential.delete)
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
        try await interactor.delete(id: id)
        return AdminNotificationFlash.redirect(
            to: "/admin/auth/credentials/",
            notification: .init(
                title: "Removed",
                message: "User credential removed successfully."
            )
        )
    }
}
