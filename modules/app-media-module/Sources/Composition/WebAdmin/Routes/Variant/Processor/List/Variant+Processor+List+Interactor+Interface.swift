import FeatherWebAdmin
import MediaAdminAPI
import MediaModule

extension Variant.Processor.List.Interactor {
    protocol Interface: Sendable {
        func list(
            variantId: String,
            page: Int,
            search: String?
        ) async throws -> AdminListModel<
            MediaAdminAPI.Components.Schemas
                .MediaVariantProcessorQueryItemSchema
        >
    }
}
