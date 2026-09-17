import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

protocol AdminRemoveWebPagePresenter: Sendable {

    func renderRemovePage(
        item: NewAdminRemoveItemContext
    ) async throws -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String
    ) async throws -> HTMLResponse

}
