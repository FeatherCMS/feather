import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
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
        isEdited: Bool,
        permissions: Set<String>,
        search: String?,
        referenceType: String?,
        error: String?
    ) async throws -> HTMLResponse {
        let canAccess = permissions.contains(
            WebPermissions.Metadata.list.rawValue
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
                        breadcrumb: webMetadataBreadcrumbState()
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
                    isEdited: isEdited,
                    canAccess: canAccess,
                    permissions: permissions,
                    rules: model.items,
                    page: model.page,
                    pageSize: model.pageSize,
                    total: model.total,
                    referenceTypeOptions: referenceTypeOptions,
                    search: search ?? "",
                    referenceType: referenceType ?? "",
                    deniedInfo: "Forbidden",
                    deniedMessage:
                        "Your account cannot access web metadata.",
                    breadcrumb: webMetadataBreadcrumbState()
                )
            )
        )
    }

    private func webMetadataBreadcrumbState() -> [NewAdminBreadcrumb.Link] {
        [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
            ]
    }
}
