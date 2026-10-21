import RedirectModule
import FeatherWebShared
import FeatherWebAdmin
import RedirectApplication

extension RedirectModule.Rule.Edit.Interactor {
    struct Default: Interface {
    let repository: any RedirectModule.Rule.Edit.Repository.Interface

    func load(
        id: String
    ) async throws -> RedirectRuleEditModel {
        do { return try await repository.load(id: id) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    func update(
        id: String,
        input: RedirectRuleEditFormInput
    ) async throws {
        do { try await repository.update(id: id, input: input) }
        catch let error as OpenAPIRepositoryError { throw map(error) }
    }

    private func map(_ error: OpenAPIRepositoryError)
        -> RedirectModule.Rule.Edit.Error
    {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .conflict: .conflict
        case .failure(let failure) where failure.statusCode == 409: .conflict
        default: .unavailable
        }
    }
}
}
