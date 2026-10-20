import FeatherWebAdmin
import UserModule

extension Role.Edit.Interactor {
    struct Default: Interface {
        let repository: any Role.Edit.Repository.Interface

        func load(
            id: String
        ) async throws -> Role.Detail.RepositoryModel {
            do { return try await repository.load(id: id) }
            catch let error as OpenAPIRepositoryError { throw map(error) }
        }

        func edit(
            id: String,
            input: Role.Edit.FormInput
        ) async throws {
            do {
                try await repository.update(
                    id: id,
                    payload: .init(
                        name: input.normalizedName,
                        notes: input.normalizedNotes
                    )
                )
            }
            catch let error as OpenAPIRepositoryError { throw map(error) }
        }

        private func map(_ error: OpenAPIRepositoryError) -> Role.Edit.Error {
            switch error {
            case .notFound: .notFound
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .conflict: .conflict
            default: .unavailable
            }
        }
    }
}
