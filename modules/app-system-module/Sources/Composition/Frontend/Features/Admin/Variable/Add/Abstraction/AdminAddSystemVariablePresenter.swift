import FeatherAdmin
import Hummingbird

protocol AdminAddSystemVariablePresenter: Sendable {

    func renderAddPage(
        state: SystemVariableAddForm.State
    ) async throws -> HTMLResponse

}
