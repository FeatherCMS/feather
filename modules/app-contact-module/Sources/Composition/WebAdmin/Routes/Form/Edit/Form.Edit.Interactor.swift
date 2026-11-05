import ContactApplication
import ContactModule

extension ContactModule.Form.Edit {
    enum Interactor {}
}

extension ContactModule.Form.Edit.Interactor {
    protocol Interface: Sendable {
        func get(key: String) async throws -> ContactModule.Form.Details.Item
        func update(
            key: String,
            newKey: String,
            name: String,
            successMessage: String,
            failureMessage: String,
            submitLabel: String,
            redirectUrl: String?,
            fieldIDs: [String],
            mails: [ContactModule.Form.Email]
        ) async throws
    }
}
