import FeatherContracts

public struct WebMarkdownBlockRendererRequest: Sendable, ExecutionContext {
    public let requestPath: String
    public let arguments: [String: String]
    public let children: [Child]

    public struct Child: Sendable {
        public let name: String
        public let arguments: [String: String]
        public let html: String

        public init(
            name: String,
            arguments: [String: String],
            html: String
        ) {
            self.name = name
            self.arguments = arguments
            self.html = html
        }
    }

    public init(
        requestPath: String,
        arguments: [String: String] = [:],
        children: [Child] = []
    ) {
        self.requestPath = requestPath
        self.arguments = arguments
        self.children = children
    }
}
