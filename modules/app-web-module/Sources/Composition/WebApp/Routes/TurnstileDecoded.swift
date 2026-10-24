/// Decodes a form value together with its Cloudflare Turnstile response.
public struct TurnstileDecoded<Value: Decodable & Sendable>:
    Decodable, Sendable
{
    public let data: Value
    public let token: String?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decodeIfPresent(
            String.self,
            forKey: .token
        )
        data = try Value(from: decoder)
    }

    private enum CodingKeys: String, CodingKey {
        case token = "cf-turnstile-response"
    }
}
