import FeatherWebAdmin
import Hummingbird
import MediaAdminAPI
import MediaModule

extension Variant.Processor.List.Presenter {
    protocol Interface: Sendable {
        func renderListPage(
            variantId: String,
            model: AdminListModel<
                MediaAdminAPI.Components.Schemas
                    .MediaVariantProcessorQueryItemSchema
            >,
            permissions: AdminListActions,
            search: String?
        ) async throws -> HTMLResponse

        func renderAddPage(variantId: String) async throws -> HTMLResponse

        func renderErrorPage(error: Variant.Processor.List.Error)
            async throws -> HTMLResponse
    }
}
