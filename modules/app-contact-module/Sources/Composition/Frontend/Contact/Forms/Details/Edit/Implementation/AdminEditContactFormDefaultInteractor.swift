import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditContactFormDefaultInteractor: AdminEditContactFormInteractor {
    let repository: AdminEditContactFormOpenAPIRepository

    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await repository.get(id: id)
    }

    func update(
        id: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws {
        _ = try await repository.update(
            id: id,
            name: name,
            successMessage: successMessage,
            failureMessage: failureMessage,
            redirectUrl: redirectUrl,
            fieldIDs: fieldIDs,
            mails: mails
        )
    }
}
