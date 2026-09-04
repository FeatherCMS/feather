import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditContactFormFieldDefaultInteractor:
    AdminEditContactFormFieldInteractor
{
    let repository: AdminEditContactFormFieldOpenAPIRepository
    func get(formId: String, id: String) async throws
        -> AdminContactFormFieldRow
    { try await repository.get(formId: formId, id: id) }
    func update(formId: String, id: String, form: ContactFormFieldAddForm)
        async throws
    { try await repository.update(formId: formId, id: id, form: form) }
}
