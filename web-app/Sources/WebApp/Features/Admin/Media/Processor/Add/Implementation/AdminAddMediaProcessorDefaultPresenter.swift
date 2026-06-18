import Hummingbird

struct AdminAddMediaProcessorDefaultPresenter:
    AdminAddMediaProcessorPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminAddMediaProcessorModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Add media processor - Feather CMS",
            description: "Add media processor - Feather CMS",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: MediaProcessorFormView(
                title: "Add processor",
                submitLabel: "Add",
                actionURL: "/admin/media/processors/add/",
                form: .init(
                    fileSuffix: model.fileSuffix,
                    matchExtensions: model.matchExtensions,
                    commandTemplate: model.commandTemplate,
                    error: model.error
                ),
                breadcrumb: breadcrumb()
            )
        )
    }

    private func breadcrumb() -> AdminBreadcrumb.State {
        .init(
            links: [
                .init(label: "Admin", link: "/admin/"),
                .init(label: "Media", link: "/admin/media/"),
                .init(label: "Processors", link: "/admin/media/processors/"),
                .init(label: "Add", link: "/admin/media/processors/add/"),
            ]
        )
    }
}
