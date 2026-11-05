struct AuthTurnstileDecoded<Value: Decodable & Sendable>:
    Decodable, Sendable
{
    let data: Value
    let token: String?

    init(from decoder: any Decoder) throws {
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
