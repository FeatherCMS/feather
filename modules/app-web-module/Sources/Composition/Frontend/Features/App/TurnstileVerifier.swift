/// Server-side verification for Cloudflare Turnstile form responses.
public protocol TurnstileVerifier: Sendable {
    /// Public site key used to render the browser widget.
    var siteKey: String { get }

    /// Validates a single-use widget token with the provider.
    func verify(token: String?) async throws -> Bool
}
