import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditContactFormInteractor: Sendable {
    func get(key: String) async throws -> AdminContactFormDetailsItem
    func update(
        key: String,
        newKey: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws
}
