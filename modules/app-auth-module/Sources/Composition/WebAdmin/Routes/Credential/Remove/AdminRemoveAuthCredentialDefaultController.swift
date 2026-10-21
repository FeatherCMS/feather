import AuthAdminAPI
import AuthModule
import CSS
import FeatherModuleKit
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

struct AdminRemoveAuthCredentialDefaultController:
    AdminRemoveAuthCredentialController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveAuthCredentialInteractor,
            any AdminRemoveAuthCredentialPresenter
        >

    func postRemoveCredential(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
    {
        let id = try context.requiredID()
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(
                to: Credential.Permissions.delete
            )
        else {
            return
                try await presenter.renderError(
                    item: .init(id: id, label: id),
                    error: .forbidden
                )
                .response(from: request, context: context)
        }
        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
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
