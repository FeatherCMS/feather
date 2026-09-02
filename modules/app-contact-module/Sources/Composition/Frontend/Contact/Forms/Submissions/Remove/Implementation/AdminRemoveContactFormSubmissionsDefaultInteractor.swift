import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFormSubmissionsDefaultInteractor:
    AdminRemoveContactFormSubmissionsInteractor
{
    let repository: AdminRemoveContactFormSubmissionsOpenAPIRepository
    func get(formId: String, id: String) async throws
        -> AdminContactFormSubmissionItem
    { try await repository.get(formId: formId, id: id) }
    func remove(formId: String, id: String) async throws {
        try await repository.remove(formId: formId, id: id)
    }
    func remove(formId: String, ids: [String]) async throws {
        try await repository.remove(formId: formId, ids: ids)
    }
}
