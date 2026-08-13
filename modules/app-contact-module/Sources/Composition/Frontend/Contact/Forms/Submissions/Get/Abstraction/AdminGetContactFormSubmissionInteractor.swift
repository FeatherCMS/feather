import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminGetContactFormSubmissionInteractor: Sendable {
    func get(formId: String, id: String) async throws
        -> AdminContactFormSubmissionItem
}
