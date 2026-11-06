import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.Remove.Controller {
    struct Default: Interface {
        let routes: Campaign.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Issue.Remove.Interactor.Interface,
                any Issue.Remove.Presenter.Interface
            >

        func confirm(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let newsletterId = try context.requiredParameter("newsletterId")
            let issueId = try context.requiredParameter("issueId")
            guard context.isCurrentUserAllowed(to: Issue.Permissions.delete)
            else {
                return HTMLResponse(content: "", status: .forbidden)
            }
            let item = try await runtime.interactor.get(
                newsletterId: newsletterId,
                issueId: issueId
            )
            return try await runtime.presenter.render(
                newsletterId: newsletterId,
                item: item
            )
        }

        func remove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let newsletterId = try context.requiredParameter("newsletterId")
            guard context.isCurrentUserAllowed(to: Issue.Permissions.delete)
            else {
                return Response(status: .forbidden)
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
                return Response(status: .badRequest)
            }
            try await runtime.interactor.remove(
                newsletterId: newsletterId,
                issueIds: [try context.requiredParameter("issueId")]
            )
            return AdminNotification.redirect(
                to: routes.issuesPath(newsletterId: newsletterId),
                notification: .init(
                    title: "Removed",
                    message: "Campaign issue removed successfully."
                )
            )
        }

        func removeSelected(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let newsletterId = try context.requiredParameter("newsletterId")
            guard context.isCurrentUserAllowed(to: Issue.Permissions.delete)
            else {
                return Response(status: .forbidden)
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
                return Response(status: .badRequest)
            }
            let payload = nonceRequest.input
            try await buildRuntime(request, context).interactor.remove(
                newsletterId: newsletterId,
                issueIds: payload.normalizedSelectedIds
            )
            return AdminNotification.redirect(
                to: AdminLocation.url(
                    path: routes.issuesPath(newsletterId: newsletterId),
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch
                ),
                notification: .init(
                    title: "Removed",
                    message: "Issues removed successfully."
                )
            )
        }
    }
}
