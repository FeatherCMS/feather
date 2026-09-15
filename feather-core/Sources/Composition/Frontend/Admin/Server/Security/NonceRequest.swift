import Foundation

/// Decodes a flat form payload while keeping its one-time nonce separate from
/// the feature input.
public struct NonceRequest<Input: Decodable & Sendable>:
    Decodable, Sendable
{
    public let input: Input
    public let nonce: String?

    private enum CodingKeys: String, CodingKey {
        case nonce = "_nonce"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nonce = try container.decodeIfPresent(
            String.self,
            forKey: .nonce
        )
        input = try Input(from: decoder)
    }
}
