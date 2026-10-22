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

extension Credential.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Credential.Router.Routes

        func renderPage(
            id: String,
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
                title: "Edit credential",
                content: Credential.Edit.Page(
                    state: .init(
                        id: id,
                        form: form,
                        breadcrumb: routes.breadcrumb
                    )
                )
            )
        }

        func renderError(
            id: String,
            error: OpenAPIRepositoryError,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit credential",
                content: Credential.List.Error(
                    state: .init(
                        info: error.errorTitle,
                        message: error.errorDescription,
                        breadcrumb: routes.breadcrumb
                    )
                )
            )
        }

        func formState(
            userId: String,
            emails: [AuthAdminAPI.Components.Schemas.AuthEmailSchemasDetail],
            email: String,
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
                identityOptions: emails.map {
                    .init(
                        label: $0.email,
                        value: $0.email,
                        isSelected: $0.email == email
                    )
                },
                email: .init(
                    name: "email",
                    label: "Email address",
                    value: email,
                    error: nil
                ),
                password: .init(
                    name: "password",
                    label: "New password",
                    value: password,
                    error: nil
                ),
                passwordRequired: false,
                error: nil,
                success: nil
            )
        }

        func format(error: OpenAPIRepositoryError) -> String {
            error.errorDescription
        }

    }
}
