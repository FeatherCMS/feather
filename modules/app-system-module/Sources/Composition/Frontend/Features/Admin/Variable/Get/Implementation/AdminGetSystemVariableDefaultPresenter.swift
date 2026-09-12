import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AdminGetSystemVariableDefaultPresenter: AdminGetSystemVariablePresenter {
    let request: Request
    let context: DefaultRequestContext
    let events: any EventPublisher
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        variable: SystemVariableDetailsModel,
        breadcrumb: NewAdminBreadcrumb.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "System variable details",
            content: SystemVariableDetails(
                state: .init(
                    variable: variable,
                    breadcrumb: breadcrumb
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String,
        breadcrumb: NewAdminBreadcrumb.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "System variable details",
            content: NewAdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    func breadcrumb(
        id: String
    ) -> NewAdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "System", link: "/admin/system/"),
            .init(
                label: "Variables",
                link: SystemVariableRoutes.list.description
            ),
        ])
    }
}
