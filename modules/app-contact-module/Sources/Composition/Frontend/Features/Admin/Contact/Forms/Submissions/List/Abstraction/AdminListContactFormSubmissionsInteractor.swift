import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactFormSubmissionsInteractor: Sendable {
    func list(formId: String) async throws -> [AdminContactFormSubmissionItem]
}
