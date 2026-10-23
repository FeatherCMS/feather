import ContactModule
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFormSubmissionsInteractor: Sendable {
    func get(formId: String, id: String) async throws
        -> Submission.Item
    func remove(formId: String, id: String) async throws
    func remove(formId: String, ids: [String]) async throws
}
