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

extension MagicLink.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: MagicLink.Router.Routes

        func renderPage(
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
                title: "Add user magic link",
                content: MagicLink.Add.Page(
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
                title: "Add magic link",
                content: AdminStatusView(
                    state: .init(
                        title: "Forbidden",
                        message: "Your account cannot add magic links."
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }

        func formState(
            credentialId: String = "",
            emails: [Email.Option] = [],
            isPersistent: Bool = false
        ) -> MagicLink.Add.Form.State {
            .init(
                credentialId: .init(
                    key: "credential_id",
                    label: "Auth email",
                    value: credentialId,
                    error: nil
                ),
                emailOptions: emails.map {
                    .init(
                        label: $0.email,
                        value: $0.id,
                        isSelected: $0.id == credentialId
                    )
                },
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

        func format(
            error: OpenAPIRepositoryError
        ) -> String {
            error.errorDescription
        }
    }
}
