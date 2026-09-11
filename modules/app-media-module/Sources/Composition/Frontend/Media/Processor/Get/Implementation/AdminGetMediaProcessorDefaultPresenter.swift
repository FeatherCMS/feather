import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminGetMediaProcessorDefaultPresenter: AdminGetMediaProcessorPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminGetMediaProcessorModel?,
        id: String,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse {
        let breadcrumb = mediaProcessorsBreadcrumb(includeCollection: true)
        if let model {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Media processor details",
                description: "Media processor details",
                imagePath: "images/logos/logo.png",
                sidebarState: renderEngine.adminSidebarState(
                    request: request,
                    permissions: permissions
                ),
                content: MediaProcessorDetailsView(
                    item: model.item,
                    breadcrumb: breadcrumb
                )
            )
        }
        return renderEngine.renderAdminPage(
            request: request,
            title: "Media processor details",
            description: "Media processor details",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: MediaProcessorErrorView(
                info: error ?? "Processor not found.",
                breadcrumb: breadcrumb
            )
        )
    }

    private func mediaProcessorsBreadcrumb(
        includeCollection: Bool = false
    ) -> AdminBreadcrumb.State {
        var links: [AdminBreadcrumb.State.Link] = [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Media", link: "/admin/media/")
        ]
        if includeCollection {
            links.append(.init(
                label: "Processors",
                link: "/admin/media/processors/"
            ))
        }
        return .init(links: links)
    }
}
