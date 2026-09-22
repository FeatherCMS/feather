import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormDefaultInteractor: AdminEditContactFormInteractor {
    let repository: AdminEditContactFormOpenAPIRepository

    func get(key: String) async throws -> AdminContactFormDetailsItem {
        do {
            return try await repository.get(key: key)
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    func update(
        key: String,
        newKey: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws {
        do {
            _ = try await repository.update(
                key: key,
                newKey: newKey,
                name: name,
                successMessage: successMessage,
                failureMessage: failureMessage,
                redirectUrl: redirectUrl,
                fieldIDs: fieldIDs,
                mails: mails
            )
        }
        catch let error as OpenAPIRepositoryError {
            throw map(error)
        }
    }

    private func map(
        _ error: OpenAPIRepositoryError
    ) -> AdminEditContactFormError {
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
