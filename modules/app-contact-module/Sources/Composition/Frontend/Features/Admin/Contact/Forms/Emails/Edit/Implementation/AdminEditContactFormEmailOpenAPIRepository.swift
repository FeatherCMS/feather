import ContactAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormEmailOpenAPIRepository {
    let api: ContactAdminAPIClient
    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await AdminViewContactFormOpenAPIRepository(api: api).get(key: id)
    }
    func update(
        id: String,
        name: String,
        successMessage: String,
        failureMessage: String,
        redirectUrl: String?,
        fieldIDs: [String],
        mails: [AdminContactFormEmail]
    ) async throws -> AdminContactFormDetailsItem {
        try await AdminEditContactFormOpenAPIRepository(api: api)
            .update(
                key: id,
                newKey: id,
                name: name,
                successMessage: successMessage,
                failureMessage: failureMessage,
                redirectUrl: redirectUrl,
                fieldIDs: fieldIDs,
                mails: mails
            )
    }
}
