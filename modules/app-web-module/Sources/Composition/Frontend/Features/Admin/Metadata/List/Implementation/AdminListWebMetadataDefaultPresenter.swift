import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemContracts
import WebBuilders
import WebComponents
import WebContracts

struct AdminListWebMetadataDefaultPresenter:
    AdminListWebMetadataPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderEngine: any RenderingEngine
    let referenceTypeOptions: [WebMetadataReferenceTypeOption]

    func renderListPage(
        model: AdminListWebMetadataModel,
        permissions: Set<String>,
        search: String?,
        referenceType: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let actions = NewAdminListActions(
            Set(
                permissions.contains(SystemPermissions.Admin.access.rawValue)
                    ? [SystemPermissions.Admin.access]
                    : []
            )
        )
        if let error {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Manage web metadata",
                content: WebMetadataError(
                    state: .init(
                        info: "Unable to load web metadata.",
                        message: error,
                        breadcrumb: WebAdminRoutes.breadcrumb
                    )
                )
            )
        }
        guard actions.allows(SystemPermissions.Admin.access) else {
            return try await renderEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Manage web metadata",
                content: WebMetadataError(
                    state: .init(
                        info: "Forbidden",
                        message: "Your account cannot access web metadata.",
                        breadcrumb: WebAdminRoutes.breadcrumb
                    )
                )
            )
        }
        return try await renderEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage web metadata",
            content: WebMetadataTable(
                state: .init(
                    permissions: actions,
                    metadata: model.items,
                    pageState: .init(
                        page: model.page,
                        pageSize: model.pageSize,
                        total: model.total
                    ),
                    search: search,
                    referenceType: referenceType,
                    referenceTypeOptions: referenceTypeOptions,
                    breadcrumb: WebAdminRoutes.breadcrumb
                )
            )
        )
    }

}
