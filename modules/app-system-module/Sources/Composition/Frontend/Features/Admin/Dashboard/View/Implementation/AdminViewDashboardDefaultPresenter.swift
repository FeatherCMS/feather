import FeatherAdmin
import HTML
import Hummingbird
import SGML

struct AdminViewDashboardDefaultPresenter: AdminViewDashboardPresenter {
    let request: Request
    let renderingEngine: any RenderingEngine
    let permissions: Set<String>

    func renderPage(
        model: AdminViewDashboardModel
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
            content: AdminViewDashboardComponent(model: model)
        )
    }
}
