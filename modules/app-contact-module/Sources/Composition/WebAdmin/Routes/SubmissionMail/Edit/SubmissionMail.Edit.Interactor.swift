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

extension SubmissionMail.Edit {
    enum Interactor {}
}

extension SubmissionMail.Edit.Interactor {
    protocol Interface: Sendable {
        func get(id: String) async throws -> ContactModule.Form.Details.Item
        func update(id: String, email: ContactModule.Form.Email) async throws
    }
}
