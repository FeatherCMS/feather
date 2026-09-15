import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormFieldsDefaultInteractor:
    AdminListContactFormFieldsInteractor
{
    let repository: AdminListContactFormFieldsOpenAPIRepository
    func list(formId: String) async throws -> [AdminContactFormFieldRow] {
        try await repository.list(formId: formId)
    }
}
