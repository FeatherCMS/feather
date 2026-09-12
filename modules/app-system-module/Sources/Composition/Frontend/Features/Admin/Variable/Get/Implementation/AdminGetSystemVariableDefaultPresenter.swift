import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import SystemContracts
import WebBuilders
import WebComponents

struct AdminGetSystemVariableDefaultPresenter: AdminGetSystemVariablePresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderDetailsPage(
        variable: SystemVariableDetailsModel,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "System variable details",
            content: SystemVariableDetails(
                state: .init(
                    variable: variable,
                    permissions: permissions
                )
            )
        )
    }

    func renderErrorPage(
        info: String,
        message: String
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

}
