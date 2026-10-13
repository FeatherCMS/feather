import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactFormDefaultInteractor: AdminAddContactFormInteractor {
    let repository: AdminAddContactFormOpenAPIRepository

    func availableFields() async throws -> [AdminContactFormFieldOption] {
        try await repository.availableFields()
    }

    func create(
        key: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws {
        do {
            _ = try await repository.create(
                key: key,
                name: name,
                successMessage: successMessage,
                failureMessage: failureMessage,
                redirectUrl: redirectUrl,
                fieldIDs: fieldIDs,
                mails: mails
            )
        }
        catch let error as OpenAPIRepositoryError {
            switch error {
            case .unauthorized:
                throw AdminAddContactFormError.unauthorized
            case .forbidden:
                throw AdminAddContactFormError.forbidden
            case .conflict:
                throw AdminAddContactFormError.conflict
            case .notFound, .failure, .transport:
                throw AdminAddContactFormError.unavailable
            }
        }
    }
}
