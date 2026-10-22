import FeatherWebAdmin
import Hummingbird
import MediaModule

extension Variant.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemovePage(
            items: [AdminRemoveItemContext],
            returnTo: String?
        )
            async throws -> HTMLResponse
        func renderErrorPage(error: Variant.Remove.Error, cancel: String)
            async throws -> HTMLResponse
        func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse
        func renderSuccess(location: String, count: Int) -> Response
    }
}
