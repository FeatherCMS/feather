import ContactAdminAPI
import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.Add {
    enum Repository {}
}

extension SubmissionMail.Add.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> AdminContactFormDetailsItem
        func update(
            id: String,
            name: String,
            successMessage: String,
            failureMessage: String,
            redirectUrl: String?,
            fieldIDs: [String],
            mails: [AdminContactFormEmail]
        ) async throws -> AdminContactFormDetailsItem
    }
}

extension SubmissionMail.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        func get(id: String) async throws -> AdminContactFormDetailsItem {
            try await AdminViewContactFormOpenAPIRepository(api: api)
                .get(key: id)
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
}
