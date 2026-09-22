import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFieldDefaultInteractor:
    AdminEditContactFieldInteractor
{
    let repository: AdminEditContactFieldOpenAPIRepository
    func get(id: String) async throws -> AdminContactFieldRow {
        do {
            return try await repository.get(id: id)
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }
    func update(id: String, form: ContactFieldFormInput) async throws {
        do {
            try await repository.update(id: id, form: form)
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(
        _ error: OpenAPIRepositoryError
    ) -> AdminEditContactFieldError {
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
