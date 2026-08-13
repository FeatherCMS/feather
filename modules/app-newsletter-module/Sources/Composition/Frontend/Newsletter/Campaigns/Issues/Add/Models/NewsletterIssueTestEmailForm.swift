import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct NewsletterIssueTestEmailForm: Decodable {
    let email: String
    let subject: String
    let content: String
}
