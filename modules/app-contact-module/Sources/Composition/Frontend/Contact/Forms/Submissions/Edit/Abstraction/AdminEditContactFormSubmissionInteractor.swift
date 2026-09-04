import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditContactFormSubmissionInteractor: Sendable {
    func update(formId: String, id: String, status: String) async throws
}
