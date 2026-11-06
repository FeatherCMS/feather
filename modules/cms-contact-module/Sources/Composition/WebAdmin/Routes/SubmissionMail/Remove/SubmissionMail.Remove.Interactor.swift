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

extension SubmissionMail.Remove {
    enum Interactor {}
}

extension SubmissionMail.Remove.Interactor {
    protocol Interface: Sendable {
        func get(id: String) async throws -> ContactModule.Form.Details.Item
        func remove(id: String, emailIds: [String]) async throws
    }
}
