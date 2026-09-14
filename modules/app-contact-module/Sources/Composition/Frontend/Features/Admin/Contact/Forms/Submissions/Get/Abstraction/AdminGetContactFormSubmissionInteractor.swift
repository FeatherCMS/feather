import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminGetContactFormSubmissionInteractor: Sendable {
    func get(formId: String, id: String) async throws
        -> AdminContactFormSubmissionItem
}
