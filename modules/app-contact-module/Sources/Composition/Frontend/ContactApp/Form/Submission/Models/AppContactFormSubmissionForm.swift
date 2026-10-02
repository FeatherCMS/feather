import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AppContactFormSubmissionForm: Codable, Sendable {
    let values: [String: String]
    let nonce: String?
    let redirect: String?
    let turnstileResponse: String?

    enum CodingKeys: String, CodingKey {
        case values
        case nonce
        case redirect
        case turnstileResponse = "cf-turnstile-response"
    }
}
