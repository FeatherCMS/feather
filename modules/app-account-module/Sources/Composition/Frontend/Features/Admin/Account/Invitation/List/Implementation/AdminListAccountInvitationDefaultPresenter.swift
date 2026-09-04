import AccountContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct AdminListAccountInvitationDefaultPresenter:
    AdminListAccountInvitationPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListAccountInvitationModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) -> HTMLResponse {
        let canAccess = permissions.contains(
            AccountPermissions.Invitations.list.rawValue
        )
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage user invitations",
                description: "Management user invitation list",
                imagePath: "images/logos/logo.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: AccountInvitationError(
                    state: .init(
                        info: "Unable to load user invitations.",
                        message: error,
                        breadcrumb: breadcrumb()
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage user invitations",
            description: "Management user invitation list",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AccountInvitationTable(
                state: .init(
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    canAccess: canAccess,
                    permissions: permissions,
                    canAdd: permissions.contains(
                        AccountPermissions.Invitations.create.rawValue
                    ),
                    invitations: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search ?? "",
                    deniedInfo: "Forbidden",
                    deniedMessage:
                        "Your identity cannot access user invitations.",
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove selected invitations",
            description: "Confirm remove",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListRemoveConfirmation(
                state: .init(
                    breadcrumb: breadcrumb(),
                    title: "Remove selected invitations",
                    message:
                        "Are you sure you want to remove these selected invitations? This action cannot be undone.",
                    action: "/admin/account/invitations/remove/",
                    cancelLink: ListRemoveRedirect.location(
                        path: "/admin/account/invitations/",
                        page: page,
                        search: search,
                        title: nil,
                        message: nil
                    ),
                    selectedIds: selectedIds
                )
            )
        )
    }

    func errorState(
        error: OpenAPIRepositoryError
    ) -> AccountInvitationError.State {
        .init(
            info: error.errorTitle,
            message: error.errorDescription,
            breadcrumb: breadcrumb()
        )
    }

    func breadcrumb() -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "User", link: "/admin/user/"),
            .init(label: "Invitations", link: "/admin/account/invitations/"),
        ])
    }
}
