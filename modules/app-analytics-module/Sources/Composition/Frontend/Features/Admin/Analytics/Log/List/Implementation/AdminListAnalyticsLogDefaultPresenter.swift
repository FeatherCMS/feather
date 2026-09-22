import AnalyticsContracts
import FeatherAdmin
import Hummingbird
import FeatherContracts

struct AdminListAnalyticsLogDefaultPresenter:
    AdminListAnalyticsLogPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine

    func renderListPage(
        model: AdminListAnalyticsLogModel,
        permissions: Set<String>,
        search: String?,
        source: String?,
        method: String?,
        responseCode: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let canAccess = permissions.contains(
            AnalyticsPermissions.Logs.list.rawValue
        )
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Analytics logs",
            content: AnalyticsLogTable(
                state: .init(
                    canAccess: canAccess,
                    permissions: .init(
                        Set(permissions.map(PermissionKey.init))
                    ),
                    logs: model.items,
                    pageState: .init(
                        page: model.page,
                        pageSize: model.pageSize,
                        total: model.total
                    ),
                    search: search ?? "",
                    source: source ?? model.source,
                    method: method ?? model.method,
                    responseCode: responseCode ?? model.responseCode,
                    error: error
                )
            )
        )
    }
}
