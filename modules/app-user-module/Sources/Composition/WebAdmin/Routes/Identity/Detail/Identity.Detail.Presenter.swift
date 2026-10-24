import FeatherWebAdmin
import HTML
import Hummingbird
import UserModule

extension Identity.Detail {
    enum Presenter {}
}

extension Identity.Detail.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            model: Identity.Detail.Model,
            permissions: AdminListActions
        ) async throws -> HTMLResponse
        func renderErrorPage(error: Identity.Detail.Error) async throws
            -> HTMLResponse
    }
}
