import AccountContracts
import FeatherAdmin
import FeatherModuleKit
import Hummingbird

struct AdminListAccountInvitationDefaultPresenter:
    AdminListAccountInvitationPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListAccountInvitationModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        if let error {
            let page = try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "User invitations",
                content: AdminStatusView(
                    state: .init(
                        title: "Unable to load user invitations",
                        message: error
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
            return HTMLResponse(
                content: page.content,
                status: .internalServerError
            )
        }

        let granted = AdminListActions(
            Set(permissions.map { PermissionKey($0) })
        )
        return try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "User invitations",
            content: AccountInvitationTable(
                state: .init(
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    canAccess: granted.allows(
                        AccountPermissions.Invitations.list
                    ),
                    permissions: granted,
                    invitations: model.items,
                    pageState: .init(
                        page: model.page,
                        pageSize: model.pageSize,
                        total: model.total
                    ),
                    search: search ?? ""
                )
            )
        )
    }
}
