import MediaAdminAPI
import MediaModule

extension Variant.Add.Repository {
    protocol Interface: Sendable {
        func create(
            input: MediaAdminAPI.Components.Schemas.MediaVariantCreateSchema
        ) async throws
    }
}
