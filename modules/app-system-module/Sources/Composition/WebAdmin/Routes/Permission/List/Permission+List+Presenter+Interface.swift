import FeatherWebAdmin
import SystemModule
import WebComponents

extension Permission.List.Presenter {
    protocol Interface: Sendable {

        func renderListPage(
            model: Permission.List.Model,
            permissions: AdminListActions,
            search: String?
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: Permission.List.Error
        ) async throws -> HTMLResponse

    }
}
