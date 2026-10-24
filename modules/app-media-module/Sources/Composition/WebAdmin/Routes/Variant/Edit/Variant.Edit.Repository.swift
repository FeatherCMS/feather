import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaAdminAPI
import MediaModule

extension Variant.Edit {
    enum Repository {}
}

extension Variant.Edit.Repository {
    protocol Interface: Sendable {
        func load(id: String) async throws
            -> MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema
        func loadProcessor(variantId: String, id: String) async throws
            -> MediaAdminAPI.Components.Schemas
            .MediaVariantProcessorDetailSchema
        func processorNames(variantId: String, ids: [String]) async throws
            -> [AdminRemoveItemContext]
        func update(
            id: String,
            input: MediaAdminAPI.Components.Schemas.MediaVariantPatchSchema
        ) async throws
        func addProcessor(
            variantId: String,
            input: MediaAdminAPI.Components.Schemas
                .MediaVariantProcessorCreateSchema
        ) async throws
        func updateProcessor(
            variantId: String,
            id: String,
            input: MediaAdminAPI.Components.Schemas
                .MediaVariantProcessorPatchSchema
        ) async throws
        func removeProcessor(variantId: String, id: String) async throws
    }
}
