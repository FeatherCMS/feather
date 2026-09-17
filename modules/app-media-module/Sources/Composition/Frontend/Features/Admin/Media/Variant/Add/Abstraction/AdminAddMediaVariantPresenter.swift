import FeatherAdmin
import FeatherValidation
import Hummingbird

protocol AdminAddMediaVariantPresenter: Sendable {
    func renderAddPage(state: MediaVariantFormView.State) async throws
        -> HTMLResponse
    func renderValidationError(
        input: MediaVariantFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse
    func renderAddError(
        input: MediaVariantFormInput?,
        error: AdminAddMediaVariantError
    ) async throws -> HTMLResponse
    func renderSuccess() -> Response
}
