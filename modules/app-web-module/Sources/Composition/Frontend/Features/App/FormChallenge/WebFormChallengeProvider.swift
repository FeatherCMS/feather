public import SGML

/// Supplies the public widget and server verification for a form challenge.
///
/// Implementations belong to application infrastructure and are optional. A
/// project chooses a provider by injecting one into the form routes and
/// Markdown renderers.
public protocol WebFormChallengeProvider: Sendable {
    var responseFieldName: String { get }
    var responseHeaderName: String { get }

    func widget(
        // empty
    ) -> [any Element]

    func verify(
        response: String?
    ) async throws -> Bool
}
