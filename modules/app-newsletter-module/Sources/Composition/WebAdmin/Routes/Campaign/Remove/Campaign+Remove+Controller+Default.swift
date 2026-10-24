import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Campaign.Remove.Controller {
    struct Default: Interface {
        let routes: Campaign.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Campaign.Remove.Interactor.Interface,
                any Campaign.Remove.Presenter.Interface
            >

        func remove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let interactor = buildRuntime(request, context).interactor
            guard context.isCurrentUserAllowed(to: Campaign.Permissions.delete)
            else { return Response(status: .forbidden) }
            let nonceRequest = try await request.decode(
                as: NonceRequest<AdminListRemoveFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    nonceRequest.nonce,
                    sessionToken: context.sessionToken
                )
            else { return Response(status: .badRequest) }
            try await interactor.remove(
                id: try context.requiredParameter("newsletterId")
            )
            return AdminNotificationFlash.redirect(
                to: routes.list.path,
                notification: .init(
                    title: "Removed",
                    message: "Campaign removed successfully."
                )
            )
        }

        func removeSelected(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let interactor = buildRuntime(request, context).interactor
            guard context.isCurrentUserAllowed(to: Campaign.Permissions.delete)
            else { return Response(status: .forbidden) }
            let nonceRequest = try await request.decode(
                as: NonceRequest<AdminListRemoveFormInput>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    nonceRequest.nonce,
                    sessionToken: context.sessionToken
                )
            else { return Response(status: .badRequest) }
            let payload = nonceRequest.input
            try await interactor.remove(ids: payload.normalizedSelectedIds)
            return AdminNotificationFlash.redirect(
                to: AdminLocation.url(
                    path: routes.list.path,
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch
                ),
                notification: .init(
                    title: "Removed",
                    message: "Campaigns removed successfully."
                )
            )
        }
    }
}
