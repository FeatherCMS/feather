import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Issue.Form {
    struct Input: Decodable {
        var subject: String = ""
        var content: String = ""
        var normalizedSubject: String {
            subject.whitespaceTrimmed
        }
    }
}
