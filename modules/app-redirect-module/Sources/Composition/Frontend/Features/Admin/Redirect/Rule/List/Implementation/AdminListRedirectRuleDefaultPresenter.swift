import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import Hummingbird
import RedirectContracts
import SGML
import WebComponents
import WebBuilders

struct AdminListRedirectRuleDefaultPresenter:
    AdminListRedirectRulePresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListRedirectRuleModel,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        search: String?,
        statusCode: String?,
        error: String?
    ) -> HTMLResponse {
        let canAccess = permissions.contains(
            RedirectPermissions.Rules.list.rawValue
        )
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage redirect rules",
                description: "Management redirect rule list",
                imagePath: "images/logos/logo.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: RedirectRuleError(
                    state: .init(
                        info: "Unable to load redirect rules.",
                        message: error,
                        breadcrumb: redirectRuleBreadcrumbState()
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage redirect rules",
            description: "Management redirect rule list",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: RedirectRuleTable(
                state: .init(
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    canAccess: canAccess,
                    permissions: permissions,
                    canAdd: permissions.contains(
                        RedirectPermissions.Rules.create.rawValue
                    ),
                    rules: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    search: search ?? "",
                    statusCode: statusCode ?? model.statusCode,
                    deniedInfo: "Forbidden",
                    deniedMessage:
                        "Your account cannot access redirect rules.",
                    breadcrumb: redirectRuleBreadcrumbState()
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
            title: "Remove selected rules",
            description: "Confirm remove",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListRemoveConfirmation(
                state: .init(
                    breadcrumb: redirectRuleBreadcrumbState(),
                    title: "Remove selected rules",
                    message:
                        "Are you sure you want to remove these selected rules? This action cannot be undone.",
                    action: "/admin/redirect/rules/remove/",
                    cancelLink: ListRemoveRedirect.location(
                        path: "/admin/redirect/rules/",
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

    private func redirectRuleBreadcrumbState() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Redirect", link: "/admin/redirect/"),
                .init(label: "Rules", link: "/admin/redirect/rules/"),
            ]
        )
    }
}
