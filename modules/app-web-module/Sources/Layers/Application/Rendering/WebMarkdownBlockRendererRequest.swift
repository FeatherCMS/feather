import FeatherContracts

public struct WebMarkdownBlockRendererRequest: Sendable, ExecutionContext {
    public let requestPath: String

    public init(requestPath: String) {
        self.requestPath = requestPath
    }
}
