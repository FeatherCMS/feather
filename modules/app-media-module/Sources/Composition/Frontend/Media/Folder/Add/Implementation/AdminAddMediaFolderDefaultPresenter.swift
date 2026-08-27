import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddMediaFolderDefaultPresenter: AdminAddMediaFolderPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminAddMediaFolderModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Add media folder - Feather CMS",
            description: "Add media folder - Feather CMS",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: MediaFolderAddView(
                state: .init(
                    form: .init(
                        parentId: model.parentId ?? "",
                        name: model.name,
                        view: model.view,
                        error: model.error
                    ),
                    breadcrumb: breadcrumb()
                )
            )
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Media", link: "/admin/media/"),
                .init(label: "Assets", link: "/admin/media/assets/"),
                .init(label: "Add", link: "/admin/media/folders/add/"),
            ]
        )
    }
}
