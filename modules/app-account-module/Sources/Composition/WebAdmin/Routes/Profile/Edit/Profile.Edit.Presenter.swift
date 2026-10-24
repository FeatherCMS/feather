import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin

extension Profile.Edit {
    enum Presenter {}
}

extension Profile.Edit.Presenter {

    protocol Interface: Sendable {

        func renderPage(
            state: Profile.Edit.Page.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderDeniedPage(
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
