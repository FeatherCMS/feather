import ContactModule
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormSubmissionsDefaultInteractor:
    AdminListContactFormSubmissionsInteractor
{
    let repository: AdminListContactFormSubmissionsOpenAPIRepository
    func list(formId: String) async throws -> [Submission.Item] {
        try await repository.list(formId: formId)
    }
}
