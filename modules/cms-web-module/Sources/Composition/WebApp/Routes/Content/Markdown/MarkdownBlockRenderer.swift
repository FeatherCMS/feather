import FeatherModuleKit

public protocol MarkdownBlockRenderer: Sendable {
    var name: String { get }
    var usesFormSubmissionNonce: Bool { get }

    func render(
        request: MarkdownBlockRendererRequest
    ) async -> String?
}

extension MarkdownBlockRenderer {
    public var usesFormSubmissionNonce: Bool { false }
}
