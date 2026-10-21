import RedirectModule
import FeatherWebShared
import FeatherWebAdmin
import RedirectApplication

extension RedirectModule.Rule.Add.Interactor {
    struct Default: Interface {
    let repository: any RedirectModule.Rule.Add.Repository.Interface

    func add(
        input: RedirectRuleAddFormInput
    ) async throws {
        do { try await repository.create(input: input) }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .unauthorized: throw RedirectModule.Rule.Add.Error.unauthorized
            case .forbidden: throw RedirectModule.Rule.Add.Error.forbidden
            case .failure(let failure) where failure.statusCode == 409:
                throw RedirectModule.Rule.Add.Error.conflict
            case .conflict: throw RedirectModule.Rule.Add.Error.conflict
            default: throw RedirectModule.Rule.Add.Error.unavailable
            }
        }
    }
    }
}
