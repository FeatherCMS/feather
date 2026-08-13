import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddContactFormFieldInteractor: Sendable {
    func getAddContactFormField(formId: String) async throws
        -> AdminAddContactFormFieldModel
    func postAddContactFormField(
        formId: String,
        payload: ContactFormFieldAddForm
    )
        async throws -> AdminAddContactFormFieldModel
}
