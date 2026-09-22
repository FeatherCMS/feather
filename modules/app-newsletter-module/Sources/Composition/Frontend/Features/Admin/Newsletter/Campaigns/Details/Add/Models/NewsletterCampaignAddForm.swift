import FeatherAdmin
import FeatherValidation
import FeatherContracts
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignAddForm: Decodable {
    var name: String = ""
    var fromEmail: String = ""

    var normalizedName: String {
        name.whitespaceTrimmed
    }

    var normalizedFromEmail: String {
        fromEmail.whitespaceTrimmed
    }
}
