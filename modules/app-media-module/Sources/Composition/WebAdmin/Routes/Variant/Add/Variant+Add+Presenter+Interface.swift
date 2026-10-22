import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import MediaModule

extension Variant.Add.Presenter {
    protocol Interface: Sendable {
        func renderAddPage(state: MediaVariantFormView.State) async throws
            -> HTMLResponse
        func renderValidationError(
            input: MediaVariantFormInput?,
            error: ValidationError
        ) async throws -> HTMLResponse
        func renderAddError(
            input: MediaVariantFormInput?,
            error: Variant.Add.Error
        ) async throws -> HTMLResponse
        func renderSuccess() -> Response
    }
}
