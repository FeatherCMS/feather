import AccountContracts
import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminListAccountInvitationDefaultPresenter:
    AdminListAccountInvitationPresenter
{
    let request: Request
    let context: DefaultRequestContext
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
            return HTMLResponse(content: page.content, status: .internalServerError)
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
                    canAccess: granted.allows(AccountPermissions.Invitations.list),
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

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        let hiddenFields = selectedIds.map {
            NewAdminConfirmation.HiddenField(name: "ids", value: $0)
        } + [
            .init(name: "page", value: "\(page)"),
            .init(name: "search", value: search ?? ""),
        ]
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove selected invitations",
            content: NewAdminConfirmation(
                breadcrumb: AccountAdminRoutes.invitationBreadcrumb + [
                    .init(label: "Remove", link: AccountAdminRoutes.invitationRemoveBulk.description)
                ],
                pageHeader: .init(
                    title: "Remove selected invitations",
                    description: "This action cannot be undone."
                ),
                selectedItems: selectedIds,
                action: AccountAdminRoutes.invitationRemoveBulk.description,
                cancel: NewAdminLocation.url(
                    path: AccountAdminRoutes.invitations.description,
                    page: page,
                    search: search
                ),
                submitLabel: "Remove invitations",
                nonceToken: nonceToken,
                hiddenFields: hiddenFields
            )
        )
    }

}
