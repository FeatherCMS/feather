import FeatherAdmin
import Hummingbird

protocol AdminAddSystemPermissionPresenter: Sendable {

    func renderAddPage(
        state: SystemPermissionAddForm.State
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse
}
