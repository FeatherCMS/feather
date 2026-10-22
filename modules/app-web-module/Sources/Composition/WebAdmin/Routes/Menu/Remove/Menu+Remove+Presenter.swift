import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain

extension Menu.Remove {
    enum Presenter {}
}

extension Menu.Remove.Presenter {
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
