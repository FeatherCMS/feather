import FeatherAdmin
import SystemModule
import WebComponents

extension WebAdmin.System.Permission.List {
    enum Presenter {}
}

extension WebAdmin.System.Permission.List.Presenter {
    protocol Interface: Sendable {

        func renderListPage(
            model: WebAdmin.System.Permission.List.Model,
            permissions: AdminListActions,
            search: String?
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: WebAdmin.System.Permission.List.Error
        ) async throws -> HTMLResponse

    }
}
