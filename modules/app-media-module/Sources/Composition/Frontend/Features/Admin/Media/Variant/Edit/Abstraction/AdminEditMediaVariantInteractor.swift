import FeatherAdmin
import MediaAdminAPI

protocol AdminEditMediaVariantInteractor: Sendable {
    func load(id: String) async throws
        -> MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema
    func loadProcessor(variantId: String, id: String) async throws
        -> MediaAdminAPI.Components.Schemas.MediaVariantProcessorDetailSchema
    func processorNames(variantId: String, ids: [String]) async throws
        -> [NewAdminRemoveItemContext]
    func update(id: String, input: MediaVariantFormInput) async throws
    func addProcessor(variantId: String, input: MediaVariantProcessorFormInput)
        async throws
    func updateProcessor(
        variantId: String,
        id: String,
        input: MediaVariantProcessorFormInput
    ) async throws
    func removeProcessor(variantId: String, id: String) async throws
}
