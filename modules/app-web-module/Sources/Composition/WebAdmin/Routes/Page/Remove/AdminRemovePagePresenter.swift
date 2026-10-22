import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminRemovePagePresenter: Sendable {

    func renderRemovePage(
        item: AdminRemoveItemContext
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String
    ) async throws -> HTMLResponse

}
