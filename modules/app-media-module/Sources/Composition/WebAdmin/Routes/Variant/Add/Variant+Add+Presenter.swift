import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Add {
    enum Presenter {}
}

extension Variant.Add.Presenter {
    protocol Interface: Sendable {
        func renderAddPage(state: Variant.Form.State) async throws
            -> HTMLResponse
        func renderValidationError(
            input: Variant.Form.Input?,
            error: ValidationError
        ) async throws -> HTMLResponse
        func renderAddError(
            input: Variant.Form.Input?,
            error: Variant.Add.Error
        ) async throws -> HTMLResponse
        func renderSuccess() -> Response
    }
}
