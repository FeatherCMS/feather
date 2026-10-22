import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModule

struct AdminListWebPageDefaultPresenter:
    AdminListWebPagePresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListWebPageModel,
        permissions: Set<String>,
        search: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let actions = AdminListActions(
            Set(
                WebModule.Permissions.Pages.allPermissions()
                    .filter {
                        permissions.contains($0.rawValue)
                    }
            )
        )
        if let error {
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage web pages",
                content: WebPageError(
                    state: .init(
                        info: "Unable to load web pages.",
                        message: error,
                        breadcrumb: WebPageRoutes.listBreadcrumb
                    )
                )
            )
        }
        guard actions.allows(WebModule.Permissions.Pages.list) else {
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage web pages",
                content: WebPageError(
                    state: .init(
                        info: "Forbidden",
                        message: "Your account cannot access web pages.",
                        breadcrumb: WebPageRoutes.listBreadcrumb
                    )
                )
            )
        }
        return try await renderEngine.renderAdminPage(
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
                    breadcrumb: WebPageRoutes.listBreadcrumb
                )
            )
        )
    }
}
