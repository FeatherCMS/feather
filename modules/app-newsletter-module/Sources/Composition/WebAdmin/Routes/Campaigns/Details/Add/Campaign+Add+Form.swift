import FeatherModuleKit
import Foundation
import NewsletterApplication
import NewsletterModule

extension Campaign.Add {
    struct Form: Decodable {
        var key: String = ""
        var name: String = ""
        var fromEmail: String = ""

        var normalizedKey: String {
            key.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        var normalizedName: String {
            name.whitespaceTrimmed
        }

        var normalizedFromEmail: String {
            fromEmail.whitespaceTrimmed
        }
    }
}
