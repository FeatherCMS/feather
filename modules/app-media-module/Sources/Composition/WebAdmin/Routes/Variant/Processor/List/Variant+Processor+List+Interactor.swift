import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaAdminAPI
import MediaModule

extension Variant.Processor.List {
    enum Interactor {}
}

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
