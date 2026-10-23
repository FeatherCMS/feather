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
        func get(id: String) async throws -> AdminContactFormDetailsItem
        func update(id: String, email: AdminContactFormEmail) async throws
    }
}
