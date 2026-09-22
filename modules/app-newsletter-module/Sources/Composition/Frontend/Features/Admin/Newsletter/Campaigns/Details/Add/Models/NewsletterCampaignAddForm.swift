import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignAddForm: Decodable {
    var key: String = ""
    var name: String = ""
    var fromEmail: String = ""

    var normalizedKey: String {
        key.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedFromEmail: String {
        fromEmail.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
