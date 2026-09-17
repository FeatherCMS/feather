import FeatherAdmin
import MediaAdminAPI

struct AdminAddMediaVariantDefaultInteractor: AdminAddMediaVariantInteractor {
    let repository: any AdminAddMediaVariantRepository

    func add(input: MediaVariantFormInput) async throws {
        do {
            try await repository.create(input: .init(
                key: input.normalizedKey,
                name: input.normalizedName,
                isRequired: input.isRequired.value,
                isActive: input.isActive.value
            ))
        }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .unauthorized: throw AdminAddMediaVariantError.unauthorized
            case .forbidden: throw AdminAddMediaVariantError.forbidden
            case .conflict: throw AdminAddMediaVariantError.conflict
            case .failure(let failure) where failure.statusCode == 409:
                throw AdminAddMediaVariantError.conflict
            case .notFound, .failure, .transport:
                throw AdminAddMediaVariantError.unavailable
            }
        }
    }
}
