import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct NewsletterIssueTestEmailForm: Decodable {
    let email: String
    let subject: String
    let content: String
}
