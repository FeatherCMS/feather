import AccountModule
import FeatherWebAdmin

extension Profile.Detail.Presenter {

    protocol Interface: Sendable {

        func renderPage(
            state: AccountProfileDetails.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderDeniedPage(
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
