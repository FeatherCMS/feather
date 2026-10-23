import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Settings.Edit.Presenter {
    struct Default: Interface {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderEngine: any RenderingEngine

    func renderPage(
        state: Settings.Edit.Page.State,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Settings",
            content: Settings.Edit.Page(state: state)
        )
    }

    func renderDeniedPage(
        info: String,
        message: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderEngine.renderAdminPage(
            request: request,
            context: context,
            title: "No permission",
            content: AdminStatusView(
                state: .init(title: info, message: message),
                icon: FeatherIcons.lock()
            )
        )
    }

}
}
