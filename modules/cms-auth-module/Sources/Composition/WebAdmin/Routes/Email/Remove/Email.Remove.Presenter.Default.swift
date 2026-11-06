import AuthAdminAPI
import AuthModule
import CSS
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

extension Email.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Email.Router.Routes

        func renderPage(
            item: AdminRemoveItemContext,
            identityId: String
        ) async throws -> HTMLResponse {
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderEngine.renderAdminDialog(
                request: request,
                context: context,
                title: AdminRemoveConfirmation.dialogTitle,
                content: Email.Remove.Confirmation(
                    state: .init(
                        item: item,
                        identityId: identityId,
                        breadcrumb: routes.breadcrumb,
                        nonceToken: nonceToken,
                        routes: routes
                    )
                ),
                size: .small
            )
        }

        func renderInvalidNoncePage() async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove user email",
                content: AdminStatusView(
                    state: .init(
                        title: "Form expired",
                        message:
                            "This form is no longer valid. Please reload the page."
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }

        func renderError(
            item: AdminRemoveItemContext,
            error: OpenAPIRepositoryError
        ) async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove user email",
                content: Email.List.Error(
                    state: .init(
                        info: error.errorTitle,
                        message: error.errorDescription,
                        breadcrumb: routes.breadcrumb
                    )
                )
            )
        }
    }
}
