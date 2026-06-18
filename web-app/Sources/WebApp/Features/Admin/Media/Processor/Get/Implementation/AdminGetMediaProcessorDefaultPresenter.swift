import Hummingbird

struct AdminGetMediaProcessorDefaultPresenter: AdminGetMediaProcessorPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminGetMediaProcessorModel?,
        id: String,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse {
        let breadcrumb = mediaProcessorsBreadcrumb(
            [
                .init(
                    label: "Details",
                    link: "/admin/media/processors/\(id)/"
                )
            ]
        )
        if let model {
            return renderEngine.renderAdminPage(
                request: request,
                title: "Media processor details - Feather CMS",
                description: "Media processor details - Feather CMS",
                imagePath: "images/puppy.png",
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
            title: "Media processor details - Feather CMS",
            description: "Media processor details - Feather CMS",
            imagePath: "images/puppy.png",
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
        _ extra: [AdminBreadcrumb.State.Link] = []
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Media", link: "/admin/media/"),
                .init(label: "Processors", link: "/admin/media/processors/"),
            ] + extra
        )
    }
}
