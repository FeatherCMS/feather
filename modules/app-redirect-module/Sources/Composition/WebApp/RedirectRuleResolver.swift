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

/// Decides whether redirect lookup applies and resolves a matching rule.
public protocol RedirectRuleResolver: Sendable {
    /// Returns whether the middleware should query for this request and response.
    func shouldLookupRedirect(
        path: String,
        method: String,
        responseCode: Int
    ) -> Bool

    /// Resolves the rule for a normalized source path, if one exists.
    func resolveRedirect(
        source: String
    ) async throws -> ResolvedRedirect?
}
