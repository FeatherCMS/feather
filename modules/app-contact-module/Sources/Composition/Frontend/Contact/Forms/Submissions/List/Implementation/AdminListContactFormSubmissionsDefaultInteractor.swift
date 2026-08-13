import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListContactFormSubmissionsDefaultInteractor:
    AdminListContactFormSubmissionsInteractor
{
    let repository: AdminListContactFormSubmissionsOpenAPIRepository
    func list(formId: String) async throws -> [AdminContactFormSubmissionItem] {
        try await repository.list(formId: formId)
    }
}
