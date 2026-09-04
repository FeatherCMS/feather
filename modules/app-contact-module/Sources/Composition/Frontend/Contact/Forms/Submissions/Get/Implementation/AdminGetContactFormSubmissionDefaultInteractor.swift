import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminGetContactFormSubmissionDefaultInteractor:
    AdminGetContactFormSubmissionInteractor
{
    let repository: AdminGetContactFormSubmissionOpenAPIRepository
    func get(formId: String, id: String) async throws
        -> AdminContactFormSubmissionItem
    { try await repository.get(formId: formId, id: id) }
}
