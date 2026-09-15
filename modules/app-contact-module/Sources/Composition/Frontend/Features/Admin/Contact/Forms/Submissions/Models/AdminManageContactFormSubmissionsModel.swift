import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminContactFormSubmissionItem: Sendable {
    let id: String
    let formId: String
    let status: String
    let createdAt: String
    let email: String?
    let values: [String: String]
}
