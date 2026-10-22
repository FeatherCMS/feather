import FeatherWebAdmin
import HTML
import Hummingbird
import UserModule

extension Identity.Detail.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            model: Identity.Detail.ViewModel,
            permissions: AdminListActions
        ) async throws -> HTMLResponse
        func renderErrorPage(error: Identity.Detail.Error) async throws
            -> HTMLResponse
    }
}
