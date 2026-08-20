// NOTE: this unchecked sendable is fine.
// WARN: never put anything into the payload apart from immutable data!
public struct WebPublicContentResult: @unchecked Sendable {
    public let payload: [String: Any]

    public init(
        payload: [String: Any]
    ) {
        self.payload = payload
    }
}
