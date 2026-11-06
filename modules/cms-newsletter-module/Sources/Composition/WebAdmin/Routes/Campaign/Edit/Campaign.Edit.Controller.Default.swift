import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Campaign.Edit.Controller {
    struct Default: Interface {
        let routes: Campaign.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Campaign.Edit.Interactor.Interface,
                any Campaign.Edit.Presenter.Interface
            >

        func edit(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredParameter("newsletterId")
            guard context.isCurrentUserAllowed(to: Campaign.Permissions.update)
            else {
                return try await runtime.presenter.render(
                    item: .init(id: id, key: "", name: "", fromEmail: ""),
                    error: "Your account cannot edit newsletter campaigns.",
                    permissions: context.currentUserPermissions
                )
            }

            do {
                return try await runtime.presenter.render(
                    item: try await runtime.interactor.get(id: id),
                    error: nil,
                    permissions: context.currentUserPermissions
                )
            }
            catch let error as Campaign.Edit.WebError {
                return try await runtime.presenter.renderErrorPage(error: error)
            }
        }

        func update(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            let id = try context.requiredParameter("newsletterId")
            guard context.isCurrentUserAllowed(to: Campaign.Permissions.update)
            else {
                return Response(status: .forbidden)
            }

            let form = try await request.decode(
                as: Campaign.Edit.Form.self,
                context: context
            )
            do {
                try await runtime.interactor.update(
                    id: id,
                    newKey: form.key,
                    name: form.name,
                    fromEmail: form.fromEmail
                )
                return AdminNotification.redirect(
                    to: routes.editPath(id),
                    notification: .init(
                        title: "Updated",
                        message: "Campaign updated successfully."
                    )
                )
            }
            catch let error as Campaign.Edit.WebError {
                return try await runtime.presenter
                    .renderEditError(
                        id: id,
                        item: .init(
                            id: id,
                            key: form.key,
                            name: form.name,
                            fromEmail: form.fromEmail
                        ),
                        error: error,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
