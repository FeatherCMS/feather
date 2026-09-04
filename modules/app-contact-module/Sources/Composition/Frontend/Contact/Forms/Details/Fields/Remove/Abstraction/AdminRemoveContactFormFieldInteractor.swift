import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminRemoveContactFormFieldInteractor: Sendable {
    func get(formId: String, id: String) async throws
        -> AdminContactFormFieldRow
    func remove(formId: String, id: String) async throws
    func remove(formId: String, ids: [String]) async throws
}
