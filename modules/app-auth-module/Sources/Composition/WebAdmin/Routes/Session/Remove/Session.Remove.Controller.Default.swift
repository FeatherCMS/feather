import AuthModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird

extension Session.Remove.Controller {
    struct Default: Interface {
        let routes: Session.Router.Routes

        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Session.Remove.Interactor.Interface,
                any Session.Remove.Presenter.Interface
            >

        func postRemoveAuthSession(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let identityId = try context.requiredID()
            let sessionId = try context.requiredParameter("sessionId")
            guard
                context.isCurrentUserAllowed(
                    to: Session.Permissions.delete
                )
            else {
                return
                    try await presenter.errorPage(
                        item: .init(id: sessionId, label: sessionId),
                        identityId: identityId,
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

            do {
                try await interactor.execute(
                    entity: .init(
                        identityId: identityId,
                        sessionId: sessionId,
                        identityEmail: "",
                        isPersistent: false,
                        expiresAt: 0,
                        createdAt: 0,
                        updatedAt: 0
                    )
                )
                return AdminNotification.redirect(
                    to: routes.identityPath(identityId),
                    notification: .init(
                        title: "Removed",
                        message: "Session removed successfully."
                    )
                )
            }
            catch let error as OpenAPIRepositoryError {
                return
                    try await presenter.errorPage(
                        item: .init(id: sessionId, label: sessionId),
                        identityId: identityId,
                        error: error
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
