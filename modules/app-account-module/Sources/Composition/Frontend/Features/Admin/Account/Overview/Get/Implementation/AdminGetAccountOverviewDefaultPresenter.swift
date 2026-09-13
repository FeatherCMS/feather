import FeatherAdmin
import HTML
import Hummingbird
import SGML

struct AdminGetAccountOverviewDefaultPresenter: AdminGetAccountOverviewPresenter
{
    let request: Request
    let renderingEngine: any RenderingEngine

    func renderOverview(
        model: AdminGetAccountOverviewModel,
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
            content: AdminGetAccountOverviewComponent()
        )
    }
}
