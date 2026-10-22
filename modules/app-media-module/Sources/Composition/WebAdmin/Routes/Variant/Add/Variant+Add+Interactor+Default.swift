import FeatherWebAdmin
import FeatherWebShared
import MediaAdminAPI
import MediaModule

extension Variant.Add.Interactor {
    struct Default: Variant.Add.Interactor.Interface {
        let repository: any Variant.Add.Repository.Interface

        func add(input: MediaVariantFormInput) async throws {
            do {
                try await repository.create(
                    input: .init(
                        key: input.normalizedKey,
                        name: input.normalizedName,
                        isRequired: input.isRequired.value,
                        isActive: input.isActive.value
                    )
                )
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .unauthorized: throw Variant.Add.Error.unauthorized
                case .forbidden: throw Variant.Add.Error.forbidden
                case .conflict: throw Variant.Add.Error.conflict
                case .failure(let failure) where failure.statusCode == 409:
                    throw Variant.Add.Error.conflict
                case .notFound, .failure, .transport:
                    throw Variant.Add.Error.unavailable
                }
            }
        }
    }
}
