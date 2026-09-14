import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddContactFormFieldInteractor: Sendable {
    func getAddContactFormField(formId: String) async throws
        -> AdminAddContactFormFieldModel
    func postAddContactFormField(
        formId: String,
        payload: ContactFormFieldAddForm
    )
        async throws -> AdminAddContactFormFieldModel
}
