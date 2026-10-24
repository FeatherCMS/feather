import FeatherWebAdmin
import FeatherWebShared
import RedirectApplication
import RedirectModule

extension Rule.Add.Interactor {
    struct Default: Interface {
        let repository: any Rule.Add.Repository.Interface

        func add(
            input: RedirectModule.Rule.Add.Form.Input
        ) async throws {
            do { try await repository.create(input: input) }
            catch let error as OpenAPIRepositoryError {
                switch error {
                case .unauthorized: throw Rule.Add.Error.unauthorized
                case .forbidden: throw Rule.Add.Error.forbidden
                case .failure(let failure) where failure.statusCode == 409:
                    throw Rule.Add.Error.conflict
                case .conflict: throw Rule.Add.Error.conflict
                default: throw Rule.Add.Error.unavailable
                }
            }
        }
    }
}
