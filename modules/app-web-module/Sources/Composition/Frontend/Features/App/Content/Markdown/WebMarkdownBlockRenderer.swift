import FeatherContracts

public protocol WebMarkdownBlockRenderer: Sendable {
    var name: String { get }

    func render(
        request: WebMarkdownBlockRendererRequest
    ) async -> String?
}
