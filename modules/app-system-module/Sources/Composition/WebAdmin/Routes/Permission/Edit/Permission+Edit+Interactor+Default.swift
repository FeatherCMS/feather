import FeatherWebAdmin
import SystemModule

extension Permission.Edit.Interactor {
    struct Default:
        Interface
    {
        let repository:
            any Permission.Edit.Repository
                .Interface

        func load(
            id: String
        ) async throws -> SystemPermissionDetailsModel {
            do {
                return try await repository.load(id: id)
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        func update(
            id: String,
            input: SystemPermissionEditFormInput
        ) async throws {
            do {
                try await repository.update(id: id, input: input)
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        private func map(
            _ error: OpenAPIRepositoryError
        ) -> Permission.Edit.Error {
            switch error {
            case .notFound: .notFound
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .conflict: .conflict
            case .failure(let failure) where failure.statusCode == 409:
                .conflict
            case .failure, .transport: .unavailable
            }
        }
    }
}
