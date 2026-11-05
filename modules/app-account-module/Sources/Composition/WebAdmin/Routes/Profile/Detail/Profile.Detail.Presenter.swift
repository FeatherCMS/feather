import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin

extension Profile.Detail {
    enum Presenter {}
}

extension Profile.Detail.Presenter {

    protocol Interface: Sendable {

        func renderPage(
            state: Profile.Detail.Page.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderDeniedPage(
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
