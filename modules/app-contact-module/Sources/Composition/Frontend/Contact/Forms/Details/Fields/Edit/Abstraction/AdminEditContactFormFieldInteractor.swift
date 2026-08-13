import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditContactFormFieldInteractor: Sendable {
    func get(formId: String, id: String) async throws
        -> AdminContactFormFieldRow
    func update(formId: String, id: String, form: ContactFormFieldAddForm)
        async throws
}
