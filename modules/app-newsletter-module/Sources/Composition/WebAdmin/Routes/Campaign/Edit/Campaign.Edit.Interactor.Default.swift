import FeatherWebAdmin
import FeatherWebShared
import NewsletterApplication
import NewsletterModule

extension Campaign.Edit.Interactor {
    struct Default: Interface {
        let repository: any Campaign.Edit.Repository.Interface

        func get(id: String) async throws -> Campaign.Item {
            do {
                return try await repository.get(id: id)
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        func update(
            id: String,
            newKey: String,
            name: String,
            fromEmail: String
        ) async throws {
            do {
                try await repository.update(
                    id: id,
                    newKey: newKey,
                    name: name,
                    fromEmail: fromEmail
                )
            }
            catch let error as OpenAPIRepositoryError {
                throw map(error)
            }
        }

        private func map(
            _ error: OpenAPIRepositoryError
        ) -> Campaign.Edit.WebError {
            switch error {
            case .notFound:
                .notFound
            case .unauthorized:
                .unauthorized
            case .forbidden:
                .forbidden
            case .conflict:
                .conflict
            case .failure, .transport:
                .unavailable
            }
        }
    }
}
