import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaAdminAPI
import MediaModule

extension Variant.Processor.List {
    enum Repository {}
}

extension Variant.Processor.List.Repository {
    protocol Interface: Sendable {
        func search(
            variantId: String,
            page: Int,
            search: String?
        ) async throws
            -> MediaAdminAPI.Components.Responses
            .MediaVariantProcessorQueryItemSearchSchemaSearchResponse
    }
}
