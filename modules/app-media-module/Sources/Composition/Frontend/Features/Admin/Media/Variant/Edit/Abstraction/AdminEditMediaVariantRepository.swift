import MediaAdminAPI

protocol AdminEditMediaVariantRepository: Sendable {
    func load(id: String) async throws -> MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema
    func update(id: String, input: MediaAdminAPI.Components.Schemas.MediaVariantCreateSchema) async throws
    func addProcessor(variantId: String, input: MediaAdminAPI.Components.Schemas.MediaVariantProcessorCreateSchema) async throws
    func updateProcessor(variantId: String, id: String, input: MediaAdminAPI.Components.Schemas.MediaVariantProcessorCreateSchema) async throws
    func removeProcessor(variantId: String, id: String) async throws
}
