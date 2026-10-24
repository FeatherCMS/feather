import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Campaign.Add.Controller {
    struct Default: Interface {
        let routes: Campaign.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Campaign.Add.Interactor.Interface,
                any Campaign.Add.Presenter.Interface
            >

        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            guard context.isCurrentUserAllowed(to: Campaign.Permissions.create)
            else {
                return try await runtime.presenter.renderPage(
                    model: .init(
                        key: "",
                        name: "",
                        fromEmail: "",
                        error:
                            "Your account cannot create newsletter campaigns."
                    ),
                    permissions: context.currentUserPermissions
                )
            }

            return try await runtime.presenter.renderPage(
                model: try await runtime.interactor.get(),
                permissions: context.currentUserPermissions
            )
        }

        func add(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let runtime = buildRuntime(request, context)
            guard context.isCurrentUserAllowed(to: Campaign.Permissions.create)
            else {
                return try await runtime.presenter
                    .renderPage(
                        model: .init(
                            key: "",
                            name: "",
                            fromEmail: "",
                            error:
                                "Your account cannot create newsletter campaigns."
                        ),
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }

            let payload = try await request.decode(
                as: Campaign.Add.Form.self,
                context: context
            )

            do {
                _ = try await runtime.interactor.add(payload: payload)
                return AdminNotificationFlash.redirect(
                    to: routes.list.path,
                    notification: .init(
                        title: "Added",
                        message: "Campaign added successfully."
                    )
                )
            }
            catch let error as Campaign.Add.WebError {
                return try await runtime.presenter
                    .renderAddError(
                        input: payload,
                        error: error,
                        permissions: context.currentUserPermissions
                    )
                    .response(from: request, context: context)
            }
        }
    }
}
