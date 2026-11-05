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
