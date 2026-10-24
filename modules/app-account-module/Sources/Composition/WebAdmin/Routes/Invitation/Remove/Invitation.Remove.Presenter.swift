import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Remove {
    enum Presenter {}
}

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
