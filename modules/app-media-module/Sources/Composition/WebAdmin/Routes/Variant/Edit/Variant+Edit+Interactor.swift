import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaAdminAPI
import MediaModule

extension Variant.Edit {
    enum Interactor {}
}

extension Variant.Edit.Interactor {
    protocol Interface: Sendable {
        func load(id: String) async throws
            -> MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema
        func loadProcessor(variantId: String, id: String) async throws
            -> MediaAdminAPI.Components.Schemas
            .MediaVariantProcessorDetailSchema
        func processorNames(variantId: String, ids: [String]) async throws
            -> [AdminRemoveItemContext]
        func update(id: String, input: Variant.Form.Input) async throws
        func addProcessor(
            variantId: String,
            input: Variant.Processor.Form.Input
        )
            async throws
        func updateProcessor(
            variantId: String,
            id: String,
            input: Variant.Processor.Form.Input
        ) async throws
        func removeProcessor(variantId: String, id: String) async throws
    }
}
