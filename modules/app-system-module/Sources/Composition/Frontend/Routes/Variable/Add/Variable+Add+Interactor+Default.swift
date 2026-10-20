import FeatherAdmin
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Variable.Add.Interactor {
    struct Default: WebAdmin.System.Variable.Add.Interactor.Interface {
        let repository: any WebAdmin.System.Variable.Add.Repository.Interface

        func add(
            input: SystemVariableAddFormInput
        ) async throws {
            do {
                try await repository.create(
                    input: .init(
                        key: input.normalizedKey,
                        value: input.normalizedValue,
                        name: input.normalizedName,
                        notes: input.normalizedNotes
                    )
                )
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        private func map(
            _ error: OpenAPIRepositoryError
        ) -> WebAdmin.System.Variable.Add.Error {
            switch error {
            case .unauthorized:
                .unauthorized
            case .forbidden:
                .forbidden
            case .conflict:
                .conflict
            case .failure(let failure) where failure.statusCode == 409:
                .conflict
            case .failure, .transport:
                .unavailable
            case .notFound:
                .unavailable
            }
        }
    }
}
