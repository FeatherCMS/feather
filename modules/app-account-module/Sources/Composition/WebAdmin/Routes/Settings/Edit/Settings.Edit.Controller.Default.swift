import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Settings.Edit.Controller {

    struct Default: Interface {
        let routes: Settings.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Settings.Edit.Interactor.Interface,
                any Settings.Edit.Presenter.Interface
            >

        func getEdit(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let targetUserID = context.parameters.get("userId", as: String.self)
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let permissions = context.currentUserPermissions
            let canRead =
                targetUserID == nil
                || context.isCurrentUserAllowed(
                    to: Settings.Permissions.read
                )
            let canEdit =
                targetUserID == nil
                || context.isCurrentUserAllowed(
                    to: Settings.Permissions.update
                )

            guard canRead else {
                return try await presenter.renderDeniedPage(
                    info: "No permission",
                    message: "Your account cannot view the settings.",
                    permissions: permissions
                )
            }

            let settings = try await interactor.loadSettings()
            return try await presenter.renderPage(
                state: .init(
                    userID: targetUserID,
                    canEdit: canEdit,
                    form: .init(
                        language: .init(
                            key: "language",
                            label: "Language",
                            value: settings.language,
                            error: nil
                        ),
                        timezone: .init(
                            key: "timezone",
                            label: "Timezone",
                            value: settings.timezone,
                            error: nil
                        ),
                        pageSize: .init(
                            key: "pageSize",
                            label: "Pagination limit",
                            value: "\(settings.pageSize)",
                            error: nil
                        ),
                        canEdit: canEdit,
                        error: nil,
                        success: nil
                    ),
                    breadcrumb: routes.settingsBreadcrumb
                ),
                permissions: permissions
            )
        }

        func postEdit(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let targetUserID = context.parameters.get("userId", as: String.self)
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let permissions = context.currentUserPermissions
            let canEdit =
                targetUserID == nil
                || context.isCurrentUserAllowed(
                    to: Settings.Permissions.update
                )

            guard canEdit else {
                return
                    try await presenter.renderDeniedPage(
                        info: "No permission",
                        message: "Your account cannot edit the settings.",
                        permissions: permissions
                    )
                    .response(from: request, context: context)
            }

            let nonceRequest = try await request.decode(
                as: NonceRequest<Settings.Edit.Form.Input>.self,
                context: context
            )
            guard
                await AdminNonceStore.shared.consume(
                    nonceRequest.nonce,
                    sessionToken: context.sessionToken
                )
            else {
                return AdminNotification.redirect(
                    to: request.uri.path,
                    notification: .init(
                        title: "Expired",
                        message:
                            "This form has expired. Please reload the page."
                    )
                )
            }
            try await interactor.saveSettings(input: nonceRequest.input)
            return AdminNotification.redirect(
                to: request.uri.path,
                notification: .init(
                    title: "Saved",
                    message: "Settings edited successfully."
                )
            )
        }

    }
}
