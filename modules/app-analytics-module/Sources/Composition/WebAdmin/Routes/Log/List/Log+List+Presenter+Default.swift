import AnalyticsModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Log.List.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderEngine: any RenderingEngine

        func renderListPage(
            model: Log.List.Model,
            permissions: Set<String>,
            search: String?,
            source: String?,
            method: String?,
            responseCode: String?,
            from: String,
            to: String,
            error: String?
        ) async throws -> HTMLResponse {
            let canAccess = permissions.contains(
                Log.Permissions.list.rawValue
            )
            return try await renderEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Analytics logs",
                content: Log.List.Component(
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
                        from: from,
                        to: to,
                        error: error
                    )
                )
            )
        }
    }
}
