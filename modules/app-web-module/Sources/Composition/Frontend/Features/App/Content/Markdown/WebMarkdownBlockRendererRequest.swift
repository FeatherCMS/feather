public import FeatherContracts

public struct WebMarkdownBlockRendererRequest: Sendable, ExecutionContext {
    public let arguments: [String: String]
    public let rawArguments: String
    public let children: [Child]
    public let formSubmissionNonce: String?
    public let formSubmissionFeedback: WebFormSubmissionFeedback?

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
        arguments: [String: String] = [:],
        rawArguments: String = "",
        children: [Child] = [],
        formSubmissionNonce: String? = nil,
        formSubmissionFeedback: WebFormSubmissionFeedback? = nil
    ) {
        self.arguments = arguments
        // TODO: eliminate this, it's used for legacy @Video { "url" } blocks only
        self.rawArguments = rawArguments
        self.children = children
        self.formSubmissionNonce = formSubmissionNonce
        self.formSubmissionFeedback = formSubmissionFeedback
    }
}
