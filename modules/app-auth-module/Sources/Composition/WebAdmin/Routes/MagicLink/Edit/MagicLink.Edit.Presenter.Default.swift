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

extension MagicLink.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: MagicLink.Router.Routes

        func formState(
            credentialId: String = "",
            isPersistent: Bool = false
        ) -> MagicLink.Add.Form.State {
            .init(
                credentialId: .init(
                    key: "credential_id",
                    label: "Auth email ID",
                    value: credentialId,
                    error: nil
                ),
                isPersistent: .init(
                    key: "is_persistent",
                    label: "Persistent link",
                    value: isPersistent,
                    error: nil
                ),
                error: nil,
                success: nil
            )
        }

        func renderPage(
            id: String,
            isEdited: Bool,
            form: MagicLink.Add.Form.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            var form = form
            form.nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit user magic link",
                content: MagicLink.Edit.Form.Component(
                    state: .init(
                        id: id,
                        isEdited: isEdited,
                        form: form,
                        breadcrumb: routes.breadcrumb,
                        routes: routes
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
                title: "Edit user magic link",
                content: MagicLink.View.Error(
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
