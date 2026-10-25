import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Edit {
    enum Presenter {}
}

extension Variant.Edit.Presenter {
    protocol Interface: Sendable {
        func renderEditPage(
            id: String,
            detail: Variant.Edit.Model,
            state: Variant.Form.State,
            permissions: AdminListActions
        ) async throws -> HTMLResponse
        func renderProcessorEditPage(
            variantId: String,
            processor: Variant.Processor.Edit.Model,
            permissions: AdminListActions
        ) async throws -> HTMLResponse
        func renderErrorPage(error: Variant.Edit.Error) async throws
            -> HTMLResponse
        func renderSuccess(id: String) -> Response
    }
}
