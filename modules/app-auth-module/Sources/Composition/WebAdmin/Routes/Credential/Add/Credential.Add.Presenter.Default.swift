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

extension Credential.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Credential.Router.Routes

        func renderPage(
            form: Credential.Form.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            var form = form
            form.nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add credential",
                content: Credential.Add.Page(
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
                title: "Add credential",
                content: AdminStatusView(
                    state: .init(
                        title: "Forbidden",
                        message: "Your account cannot add user credentials."
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }

        func formState(
            userId: String = "",
            email: String = "",
            password: String = ""
        )
            -> Credential.Form.Component.State
        {
            .init(
                identity: .init(
                    key: "userId",
                    label: "User identity",
                    value: userId,
                    error: nil
                ),
                email: .init(
                    name: "email",
                    label: "Email address",
                    value: email,
                    error: nil
                ),
                password: .init(
                    name: "password",
                    label: "Password",
                    value: password,
                    error: nil
                ),
                passwordRequired: true,
                error: nil,
                success: nil
            )
        }

        func format(error: OpenAPIRepositoryError) -> String {
            error.errorDescription
        }

    }
}
