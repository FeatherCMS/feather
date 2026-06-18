import HTML
import Hummingbird
import SGML

struct AdminGetHomeDefaultPresenter: AdminGetHomePresenter {
    let request: Request
    let renderingEngine: any RenderingEngine
    let permissions: Set<String>

    func renderPage(
        model: AdminGetHomeModel
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: model.title,
            description: model.description,
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminGetHomeComponent(model: model)
        )
    }
}
