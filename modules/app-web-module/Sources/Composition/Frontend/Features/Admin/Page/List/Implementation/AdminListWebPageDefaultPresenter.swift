import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct AdminListWebPageDefaultPresenter:
    AdminListWebPagePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListWebPageModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let actions = NewAdminListActions(
            Set(
                WebPermissions.Pages.allPermissions()
                    .filter {
                        permissions.contains($0.rawValue)
                    }
            )
        )
        if let error {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Manage web pages",
                content: WebPageError(
                    state: .init(
                        info: "Unable to load web pages.",
                        message: error,
                        breadcrumb: webPageBreadcrumbState()
                    )
                )
            )
        }
        guard actions.allows(WebPermissions.Pages.list) else {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Manage web pages",
                content: WebPageError(
                    state: .init(
                        info: "Forbidden",
                        message: "Your account cannot access web pages.",
                        breadcrumb: webPageBreadcrumbState()
                    )
                )
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage web pages",
            content: WebPageTable(
                state: .init(
                    permissions: actions,
                    pages: model.items,
                    pageState: .init(
                        page: model.page,
                        pageSize: model.pageSize,
                        total: model.total
                    ),
                    search: search,
                    breadcrumb: webPageBreadcrumbState()
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
        try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove selected pages",
            content: NewAdminRemoveConfirmation(
                breadcrumb: webPageBreadcrumbState(),
                pageHeader: .init(
                    title: "Remove selected pages",
                    description: "This action cannot be undone."
                ),
                selectedItems: selectedIds,
                action: WebPageRoutes.remove.description,
                cancel: NewAdminLocation.url(
                    path: WebPageRoutes.list.description,
                    page: page,
                    search: search
                ),
                hiddenFields: selectedIds.map {
                    .init(name: "ids", value: $0)
                }
            )
        )
    }

    private func webPageBreadcrumbState() -> [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Web", link: "/admin/web/"),
        ]
    }
}
