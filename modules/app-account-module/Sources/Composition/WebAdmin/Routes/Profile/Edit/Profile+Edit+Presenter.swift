import AccountModule
import FeatherWebAdmin

extension Profile.Edit.Presenter {

    protocol Interface: Sendable {

        func renderPage(
            state: AccountProfileEdit.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderDeniedPage(
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
