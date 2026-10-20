import FeatherAdmin
import HTML
import SystemModule
import WebComponents

extension WebAdmin.System.Variable.View {
    enum Presenter {}
}

extension WebAdmin.System.Variable.View.Presenter {
    protocol Interface: Sendable {

        func renderDetailsPage(
            variable: SystemVariableDetailsModel,
            permissions: AdminListActions
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: WebAdmin.System.Variable.View.Error
        ) async throws -> HTMLResponse

    }
}
