import FeatherAdmin
import MediaAdminAPI

struct AdminEditMediaVariantDefaultInteractor: AdminEditMediaVariantInteractor {
    let repository: any AdminEditMediaVariantRepository

    func load(id: String) async throws -> MediaAdminAPI.Components.Schemas.MediaVariantDetailSchema {
        do { return try await repository.load(id: id) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func update(id: String, input: MediaVariantFormInput) async throws {
        do {
            try await repository.update(id: id, input: .init(key: input.normalizedKey, name: input.normalizedName, isRequired: input.isRequired.value, isActive: input.isActive.value))
        }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func addProcessor(variantId: String, input: MediaVariantProcessorFormInput) async throws {
        do { try await repository.addProcessor(variantId: variantId, input: .init(name: input.normalizedName, matchExtensions: input.normalizedExtensions, commandTemplate: input.normalizedCommand, isActive: input.isActive.value)) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func updateProcessor(variantId: String, id: String, input: MediaVariantProcessorFormInput) async throws {
        do { try await repository.updateProcessor(variantId: variantId, id: id, input: .init(name: input.normalizedName, matchExtensions: input.normalizedExtensions, commandTemplate: input.normalizedCommand, isActive: input.isActive.value)) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func removeProcessor(variantId: String, id: String) async throws {
        do { try await repository.removeProcessor(variantId: variantId, id: id) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    private func map(_ error: OpenAPIRepositoryError) -> AdminEditMediaVariantError {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .conflict: .conflict
        case .failure(let failure) where failure.statusCode == 409: .conflict
        case .failure, .transport: .unavailable
        }
    }
}
