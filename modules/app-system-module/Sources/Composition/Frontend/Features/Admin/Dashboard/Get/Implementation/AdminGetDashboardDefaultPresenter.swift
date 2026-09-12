import FeatherAdmin
import HTML
import Hummingbird
import SGML

struct AdminGetDashboardDefaultPresenter: AdminGetDashboardPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine
    let permissions: Set<String>

    func renderPage(
        model: AdminGetDashboardModel
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: model.title,
            description: model.description,
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminGetDashboardComponent(model: model)
        )
    }
}
