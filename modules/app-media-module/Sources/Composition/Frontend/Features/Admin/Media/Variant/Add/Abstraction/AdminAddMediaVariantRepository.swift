import MediaAdminAPI

protocol AdminAddMediaVariantRepository: Sendable {
    func create(
        input: MediaAdminAPI.Components.Schemas.MediaVariantCreateSchema
    ) async throws
}
