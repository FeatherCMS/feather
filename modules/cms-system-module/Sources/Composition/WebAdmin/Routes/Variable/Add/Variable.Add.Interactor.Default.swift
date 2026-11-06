import FeatherWebAdmin
import FeatherWebShared
import SystemAdminAPI
import SystemModule

extension Variable.Add.Interactor {
    struct Default: Interface {
        let repository: any Variable.Add.Repository.Interface

        func add(
            input: Variable.Add.Form.Input
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
        ) -> Variable.Add.Error {
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
