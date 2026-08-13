import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddContactFormDefaultInteractor: AdminAddContactFormInteractor {
    let repository: AdminAddContactFormOpenAPIRepository

    func availableFields() async throws -> [AdminContactFormFieldOption] {
        try await repository.availableFields()
    }

    func create(
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws {
        _ = try await repository.create(
            name: name,
            successMessage: successMessage,
            failureMessage: failureMessage,
            redirectUrl: redirectUrl,
            fieldIDs: fieldIDs,
            mails: mails
        )
    }
}
