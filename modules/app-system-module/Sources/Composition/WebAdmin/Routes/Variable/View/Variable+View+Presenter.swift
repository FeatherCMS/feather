import FeatherAdmin
import HTML
import SystemModule
import WebComponents

extension Variable.View {
    enum Presenter {}
}

extension Variable.View.Presenter {
    protocol Interface: Sendable {

        func renderDetailsPage(
            variable: SystemVariableDetailsModel,
            permissions: AdminListActions
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: Variable.View.Error
        ) async throws -> HTMLResponse

    }
}
