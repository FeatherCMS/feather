import FeatherAdmin
import Hummingbird

protocol AdminRemoveSystemVariablePresenter: Sendable {

    func renderErrorPage(
        info: String,
        message: String,
        cancel: String,
    ) async throws -> HTMLResponse

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        ids: [String],
        names: [String],
        fromDetails: Bool
    ) async throws -> HTMLResponse

}
