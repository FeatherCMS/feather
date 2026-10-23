import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaAdminAPI
import MediaModule

extension Variant.Edit {
    enum Presenter {}
}

extension Variant.Edit.Presenter {
    protocol Interface: Sendable {
        func renderEditPage(
            id: String,
            detail: MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema,
            state: MediaVariantFormView.State,
            permissions: AdminListActions
        ) async throws -> HTMLResponse
        func renderProcessorEditPage(
            variantId: String,
            processor: MediaAdminAPI.Components.Schemas
                .MediaVariantProcessorDetailSchema,
            permissions: AdminListActions
        ) async throws -> HTMLResponse
        func renderErrorPage(error: Variant.Edit.Error) async throws
            -> HTMLResponse
        func renderSuccess(id: String) -> Response
    }
}
