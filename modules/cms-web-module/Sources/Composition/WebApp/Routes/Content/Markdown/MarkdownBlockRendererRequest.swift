public import FeatherModuleKit

public struct MarkdownBlockRendererRequest: Sendable, ExecutionContext {
    public let arguments: [String: String]
    public let children: [Child]
    public let formSubmissionNonce: String?
    public let formSubmissionFeedback: FormSubmissionFeedback?

    public struct Child: Sendable {
        public let name: String
        public let arguments: [String: String]
        public let html: String
        public let children: [Child]

        public init(
            name: String,
            arguments: [String: String],
            html: String,
            children: [Child] = []
        ) {
            self.name = name
            self.arguments = arguments
            self.html = html
            self.children = children
        }
    }

    public init(
        arguments: [String: String] = [:],
        children: [Child] = [],
        formSubmissionNonce: String? = nil,
        formSubmissionFeedback: FormSubmissionFeedback? = nil
    ) {
        self.arguments = arguments
        self.children = children
        self.formSubmissionNonce = formSubmissionNonce
        self.formSubmissionFeedback = formSubmissionFeedback
    }
}
