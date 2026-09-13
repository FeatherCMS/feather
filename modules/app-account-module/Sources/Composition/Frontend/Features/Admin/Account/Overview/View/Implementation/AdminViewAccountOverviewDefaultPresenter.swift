import FeatherAdmin
import HTML
import Hummingbird
import SGML

struct AdminViewAccountOverviewDefaultPresenter:
    AdminViewAccountOverviewPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderOverview(
        model: AdminViewAccountOverviewModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: model.title,
            description: "This is the admin home interface",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminViewAccountOverviewComponent()
        )
    }
}
