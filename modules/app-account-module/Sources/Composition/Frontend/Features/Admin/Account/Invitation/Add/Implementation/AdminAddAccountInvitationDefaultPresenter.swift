import FeatherAdmin
import Hummingbird

struct AdminAddAccountInvitationDefaultPresenter:
    AdminAddAccountInvitationPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        form: AccountInvitationForm.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        var form = form
        form.nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add user invitation",
            content: AccountInvitationAdd(
                state: .init(
                    form: form,
                    breadcrumb: AccountAdminRoutes.invitationBreadcrumb
                )
            )
        )
    }

    func formState(
        email: String = "",
        roleIDs: [String] = [],
        roleOptions: [AccountInvitationForm.RoleOptionState] = []
    ) -> AccountInvitationForm.State {
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
