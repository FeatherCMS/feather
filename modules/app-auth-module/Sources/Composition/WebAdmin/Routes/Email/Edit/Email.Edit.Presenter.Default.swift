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

extension Email.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Email.Router.Routes

        func formState(
            identityId: String = "",
            identities: [Credential.Form.IdentityOption] = [],
            email: String = ""
        ) -> Email.Form.Component.State {
            .init(
                identityId: .init(
                    key: "identity_id",
                    label: "Auth email ID",
                    value: identityId,
                    error: nil
                ),
                identityOptions: identities.map {
                    .init(
                        label: $0.label,
                        value: $0.id,
                        isSelected: $0.id == identityId
                    )
                },
                email: .init(
                    key: "email",
                    label: "Email address",
                    value: email,
                    error: nil
                ),
                error: nil,
                success: nil
            )
        }

        func renderPage(
            id: String,
            isEdited: Bool,
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
                title: "Edit user email",
                content: Email.Edit.Page(
                    state: .init(
                        id: id,
                        isEdited: isEdited,
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
                title: "Edit user email",
                content: Email.List.Error(
                    state: .init(
                        info: error.errorTitle,
                        message: error.errorDescription,
                        breadcrumb: routes.breadcrumb
                    )
                )
            )
        }

        func format(
            error: OpenAPIRepositoryError
        ) -> String {
            error.errorDescription
        }
    }
}
