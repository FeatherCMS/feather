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

extension Email.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Email.Router.Routes

        func renderPage(
            form: Email.Form.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            var form = form
            form.nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add user email",
                content: Email.Add.Page(
                    state: .init(
                        form: form,
                        breadcrumb: routes.breadcrumb,
                        routes: routes
                    )
                )
            )
        }

        func renderForbiddenPage() async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add email",
                content: AdminStatusView(
                    state: .init(
                        title: "Forbidden",
                        message: "Your account cannot add user emails."
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }

        func formState(
            identityId: String = "",
        ) -> Email.Form.Component.State {
            .init(
                identityId: .init(
                    key: "identity_id",
                    label: "User identity",
                    value: identityId,
                    error: nil
                ),
                error: nil,
                success: nil
            )
        }

        func format(
            error: OpenAPIRepositoryError
        ) -> String {
            error.errorDescription
        }
    }
}
