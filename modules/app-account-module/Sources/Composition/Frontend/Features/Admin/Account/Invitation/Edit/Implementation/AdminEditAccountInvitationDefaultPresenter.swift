import FeatherAdmin
import FeatherContracts
import Foundation
import Hummingbird

struct AdminEditAccountInvitationDefaultPresenter:
    AdminEditAccountInvitationPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: AccountInvitationForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        var state = state
        state.nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit user invitation",
            content: AccountInvitationEdit(
                state: .init(
                    id: id,
                    isEdited: isEdited,
                    form: state,
                    breadcrumb: AccountAdminRoutes.invitationEditBreadcrumb(RouterPath(id))
                )
            )
        )
    }

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit user invitation",
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle()
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
