import FeatherContracts

public protocol WebMarkdownBlockRenderer: Sendable {
    var name: String { get }
    var usesFormSubmissionNonce: Bool { get }

    func render(
        request: WebMarkdownBlockRendererRequest
    ) async -> String?
}

extension WebMarkdownBlockRenderer {
    public var usesFormSubmissionNonce: Bool { false }
}
