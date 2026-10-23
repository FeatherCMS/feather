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

extension Credential.Remove.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Credential.Remove.Interactor.Interface,
                any Credential.Remove.Presenter.Interface
            >

        func postRemoveCredential(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> Response
        {
            let id = try context.requiredID()
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
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
}
