public struct HTTPErrorEnvelope: Encodable {
    private enum CodingKeys: String, CodingKey {
        case error
        case trace
    }

    private let error: any Encodable
    private let trace: ErrorTrace?

    public init(
        error: any Encodable,
        trace: ErrorTrace? = nil
    ) {
        self.error = error
        self.trace = trace
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try error.encode(to: container.superEncoder(forKey: .error))
        try container.encodeIfPresent(trace, forKey: .trace)
    }
}
