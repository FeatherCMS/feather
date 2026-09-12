import FeatherAdmin
import Hummingbird

protocol AdminAddSystemVariablePresenter: Sendable {

    func renderAddPage(
        state: SystemVariableAddForm.State
    ) async throws -> HTMLResponse

    func renderErrorPage(
        info: String,
        message: String
    ) async throws -> HTMLResponse

}
