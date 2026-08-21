import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebContracts
import WebStandards

struct AdminListWebMetadataDefaultPresenter:
    AdminListWebMetadataPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    let referenceTypeOptions: [WebMetadataReferenceTypeOption]

    func renderListPage(
        model: AdminListWebMetadataModel,
        isEdited: Bool,
        permissions: Set<String>,
        search: String?,
        referenceType: String?,
        error: String?
    ) -> HTMLResponse {
        let canAccess = permissions.contains(
            WebPermissions.Metadata.list.rawValue
        )
        if let error {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Manage metadata entries - Feather CMS",
                description: "Management web metadata list",
                imagePath: "images/puppy.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: WebMetadataError(
                    state: .init(
                        info: "Unable to load metadata entries.",
                        message: error,
                        breadcrumb: webMetadataBreadcrumbState()
                    )
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Manage metadata entries - Feather CMS",
            description: "Management web metadata list",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
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
                        "Your account cannot access metadata entries.",
                    breadcrumb: webMetadataBreadcrumbState()
                )
            )
        )
    }

    private func webMetadataBreadcrumbState() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Web", link: "/admin/web/"),
                .init(label: "Metadata", link: "/admin/web/metadata/"),
            ]
        )
    }
}
