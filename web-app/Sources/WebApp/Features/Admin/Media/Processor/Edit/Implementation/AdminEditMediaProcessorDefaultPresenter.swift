import Hummingbird

struct AdminEditMediaProcessorDefaultPresenter: AdminEditMediaProcessorPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminEditMediaProcessorModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit media processor - Feather CMS",
            description: "Edit media processor - Feather CMS",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: MediaProcessorFormView(
                title: "Edit processor",
                submitLabel: "Save",
                actionURL: "/admin/media/processors/\(model.id)/edit/",
                form: .init(
                    fileSuffix: model.fileSuffix,
                    matchExtensions: model.matchExtensions,
                    commandTemplate: model.commandTemplate,
                    error: model.error
                ),
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
                    label: "Edit",
                    link: "/admin/media/processors/\(id)/edit/"
                ),
            ]
        )
    }
}
