import FeatherWebAdmin
import FeatherWebShared
import UserModule

extension Role.Add.Interactor {
    struct Default: Interface {
        let repository: any Role.Add.Repository.Interface

        func add(
            input: Role.Add.Form.Input
        ) async throws {
            do {
                try await repository.create(
                    payload: .init(
                        key: input.normalizedKey,
                        name: input.normalizedName,
                        notes: input.normalizedNotes
                    )
                )
            }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .unauthorized: throw Role.Add.Error.unauthorized
                case .forbidden: throw Role.Add.Error.forbidden
                case .conflict: throw Role.Add.Error.conflict
                case .failure(let failure) where failure.statusCode == 409:
                    throw Role.Add.Error.conflict
                default: throw Role.Add.Error.unavailable
                }
            }
        }
    }
}
