import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminRemoveContactFormSubmissionsInteractor: Sendable {
    func get(formId: String, id: String) async throws
        -> AdminContactFormSubmissionItem
    func remove(formId: String, id: String) async throws
    func remove(formId: String, ids: [String]) async throws
}
