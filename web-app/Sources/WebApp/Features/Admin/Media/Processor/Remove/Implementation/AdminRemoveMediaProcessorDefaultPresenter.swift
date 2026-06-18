import Hummingbird

struct AdminRemoveMediaProcessorDefaultPresenter:
    AdminRemoveMediaProcessorPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminRemoveMediaProcessorModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove media processor - Feather CMS",
            description: "Remove media processor - Feather CMS",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: MediaProcessorRemoveView(
                id: model.id,
                cancelURL: "/admin/media/processors/",
                formURL: "/admin/media/processors/\(model.id)/remove/",
                breadcrumb: breadcrumb(id: model.id)
            )
        )
    }

    private func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Media", link: "/admin/media/"),
                .init(label: "Processors", link: "/admin/media/processors/"),
                .init(
                    label: "Remove",
                    link: "/admin/media/processors/\(id)/remove/"
                ),
            ]
        )
    }
}
