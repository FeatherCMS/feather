import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Add.Presenter {

    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine
        let routes: Invitation.Router.Routes

        func renderPage(
            form: Invitation.Form.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            var form = form
            form.nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add user invitation",
                content: Invitation.Add.Page(
                    routes: routes,
                    state: .init(
                        form: form,
                        breadcrumb: routes.invitationBreadcrumb
                    )
                )
            )
        }

        func formState(
            email: String = "",
            roleIDs: [String] = [],
            roleOptions: [Invitation.Form.Component.RoleOptionState] = []
        ) -> Invitation.Form.Component.State {
            .init(
                email: .init(
                    key: "email",
                    label: "Email address",
                    value: email,
                    error: nil
                ),
                roleIds: .init(
                    key: "roleIds",
                    label: "Roles",
                    value: roleIDs.joined(separator: ", "),
                    error: nil
                ),
                roleOptions: roleOptions,
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
