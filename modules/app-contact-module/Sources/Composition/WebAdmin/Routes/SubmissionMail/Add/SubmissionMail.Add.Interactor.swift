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
    enum Interactor {}
}

extension SubmissionMail.Add.Interactor {
    protocol Interface: Sendable {
        func get(id: String) async throws -> ContactModule.Form.Details.Item
        func add(id: String, email: ContactModule.Form.Email) async throws
    }
}
