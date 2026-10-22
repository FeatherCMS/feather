import AccountModule
import FeatherWebAdmin

extension Invitation.Remove.Presenter {

    protocol Interface: Sendable {

        func renderRemovePage(
            item: AdminRemoveItemContext
        ) async throws -> HTMLResponse

        func renderErrorPage(
            id: String,
            info: String,
            message: String
        ) async throws -> HTMLResponse

    }
}
