/// A redirect result independent of the generated HTTP API schema.
public struct ResolvedRedirect: Sendable, Equatable {
    public let destination: String
    public let statusCode: Int

    public init(
        destination: String,
        statusCode: Int
    ) {
        self.destination = destination
        self.statusCode = statusCode
    }
}
