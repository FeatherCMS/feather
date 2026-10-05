import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AppNewsletterCampaignSubscriptionForm: Decodable, Sendable {
    let email: String
    let nonce: String?
    let redirect: String?
    let challengeResponses: [String: String]

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        email = try container.decode(
            String.self,
            forKey: DynamicCodingKey("email")
        )
        nonce = try container.decodeIfPresent(
            String.self,
            forKey: DynamicCodingKey("nonce")
        )
        redirect = try container.decodeIfPresent(
            String.self,
            forKey: DynamicCodingKey("redirect")
        )

        var responses: [String: String] = [:]
        for key in container.allKeys
        where !["email", "nonce", "redirect"].contains(key.stringValue) {
            if let value = try? container.decode(String.self, forKey: key) {
                responses[key.stringValue] = value
            }
        }
        challengeResponses = responses
    }

    private struct DynamicCodingKey: CodingKey {
        let stringValue: String
        let intValue: Int?

        init(_ stringValue: String) {
            self.stringValue = stringValue
            intValue = nil
        }

        init?(stringValue: String) {
            self.init(stringValue)
        }

        init?(intValue: Int) {
            stringValue = String(intValue)
            self.intValue = intValue
        }
    }
}
