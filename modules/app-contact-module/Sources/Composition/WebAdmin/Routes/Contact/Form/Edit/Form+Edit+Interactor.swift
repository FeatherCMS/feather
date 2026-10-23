import ContactApplication
import ContactModule

extension ContactModule.Form.Edit {
    enum Interactor {}
}

extension ContactModule.Form.Edit.Interactor {
    protocol Interface: Sendable {
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
}
