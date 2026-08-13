import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactFormSubmissionsInteractor: Sendable {
    func list(formId: String) async throws -> [AdminContactFormSubmissionItem]
}
