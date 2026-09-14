import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewWebMenuDefaultPresenter: AdminViewWebMenuPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        rule: WebMenuDetailsModel,
        breadcrumb: [NewAdminBreadcrumb.Link],
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Menu details",
            content: WebMenuDetails(
                state: .init(
                    menu: rule,
                    breadcrumb: breadcrumb,
                    permissions: permissions
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: [NewAdminBreadcrumb.Link],
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Menu details",
            content: WebMenuError(
                state: .init(
                    info: info,
                    message: message,
                    breadcrumb: breadcrumb
                )
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> [NewAdminBreadcrumb.Link] {
        [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Web", link: "/admin/web/"),
            .init(label: "Menus", link: "/admin/web/menus/"),
        ]
    }
}
