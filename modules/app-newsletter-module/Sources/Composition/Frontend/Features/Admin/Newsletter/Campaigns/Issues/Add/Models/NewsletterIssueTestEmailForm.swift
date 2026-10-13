import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct NewsletterIssueTestEmailForm: Decodable {
    let email: String
    let subject: String
    let content: String
}
