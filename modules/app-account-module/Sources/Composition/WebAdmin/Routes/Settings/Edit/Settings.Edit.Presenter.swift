import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Settings.Edit {
    enum Presenter {}
}

extension Settings.Edit.Presenter {

    protocol Interface: Sendable {

        func renderPage(
            state: Settings.Edit.Page.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderDeniedPage(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
