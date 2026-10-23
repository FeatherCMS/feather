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

extension SubmissionMail.List {
    enum Interactor {}
}

extension SubmissionMail.List.Interactor {
    protocol Interface: Sendable {
        func get(id: String) async throws -> AdminContactFormDetailsItem
    }
}
