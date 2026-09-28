import AccountContracts
import FeatherAdmin
import FeatherContracts
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
            let page = try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "User invitations",
                content: NewAdminStatusView(
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

        let granted = NewAdminListActions(
            Set(permissions.map { PermissionKey($0) })
        )
        return try await renderEngine.renderNewAdminPage(
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

    func renderRemovePage(
        page: Int,
        search: String?,
        items: [NewAdminRemoveItemContext]
    ) async throws -> HTMLResponse {
        let hiddenFields =
            items.map {
                NewAdminFormFieldHiddenValue(
                    name: "ids",
                    value: $0.id
                )
            } + [
                .init(name: "page", value: "\(page)"),
                .init(name: "search", value: search ?? ""),
            ]
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminDialog(
            request: request,
            context: context,
            title: NewAdminRemoveConfirmation.dialogTitle,
            content: NewAdminRemoveConfirmation(
                pageHeader: .init(
                    title: "Remove selected invitations",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: AccountAdminRoutes.invitationRemoveBulk.description,
                submit: .init(label: "Remove invitations", style: .destructive),
                nonceToken: nonceToken,
                hiddenFields: hiddenFields
            ),
            size: .small
        )
    }

}
