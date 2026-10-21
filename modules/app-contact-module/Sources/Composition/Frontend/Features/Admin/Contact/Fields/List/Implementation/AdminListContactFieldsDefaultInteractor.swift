import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFieldsDefaultInteractor:
    AdminListContactFieldsInteractor
{
    let repository: AdminListContactFieldsOpenAPIRepository
    func list(formKey: String?) async throws -> AdminContactFieldsList {
        try await repository.listWithForms(formKey: formKey)
    }
}
