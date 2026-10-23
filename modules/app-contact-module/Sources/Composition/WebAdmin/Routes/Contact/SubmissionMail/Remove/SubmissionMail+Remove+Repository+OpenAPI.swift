import ContactAdminAPI
import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.Remove {
    enum Repository {}
}

extension SubmissionMail.Remove.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> ContactForm.Details.Item
        func update(
            id: String,
            name: String,
            successMessage: String,
            failureMessage: String,
            redirectUrl: String?,
            fieldIDs: [String],
            mails: [ContactForm.Email]
        ) async throws -> ContactForm.Details.Item
    }
}

extension SubmissionMail.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        func get(id: String) async throws -> ContactForm.Details.Item {
            try await ContactModule.Form.View.Repository.OpenAPI(api: api)
                .get(key: id)
        }
        func update(
            id: String,
            name: String,
            successMessage: String,
            failureMessage: String,
            redirectUrl: String?,
            fieldIDs: [String],
            mails: [ContactForm.Email]
        ) async throws -> ContactForm.Details.Item {
            try await ContactModule.Form.Edit.Repository.OpenAPI(api: api)
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
