import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct AdminRemoveSystemVariableDefaultPresenter:
    AdminRemoveSystemVariablePresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove system variable",
            description: "Remove confirmation for a management system variable",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: SystemVariableError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb(id: id)
                )
            )
        )
    }

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        ids: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Remove selected variables",
            description: "Confirm remove",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListRemoveConfirmation(
                state: .init(
                    breadcrumb: bulkBreadcrumb(),
                    title: "Remove selected variables",
                    message: "Are you sure you want to remove these selected variables? This action cannot be undone.",
                    action: SystemVariableRoutes.removeRoute.description,
                    cancelLink: ListRemoveRedirect.location(
                        path: SystemVariableRoutes.list.description,
                        page: page,
                        search: search,
                        title: nil,
                        message: nil
                    ),
                    selectedIds: ids,
                    idFieldName: "ids"
                )
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "System", link: "/admin/system/"),
                .init(label: "Variables", link: SystemVariableRoutes.list.description)]
        )
    }

    private func bulkBreadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "System", link: "/admin/system/"),
            .init(label: "Variables", link: SystemVariableRoutes.list.description)
            ]
        )
    }
}
