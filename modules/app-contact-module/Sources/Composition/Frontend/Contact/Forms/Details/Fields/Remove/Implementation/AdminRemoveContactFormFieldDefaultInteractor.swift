import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminRemoveContactFormFieldDefaultInteractor:
    AdminRemoveContactFormFieldInteractor
{
    let repository: AdminRemoveContactFormFieldOpenAPIRepository
    func get(formId: String, id: String) async throws
        -> AdminContactFormFieldRow
    { try await repository.get(formId: formId, id: id) }
    func remove(formId: String, id: String) async throws {
        try await repository.remove(formId: formId, id: id)
    }
    func remove(formId: String, ids: [String]) async throws {
        try await repository.remove(formId: formId, ids: ids)
    }
}
