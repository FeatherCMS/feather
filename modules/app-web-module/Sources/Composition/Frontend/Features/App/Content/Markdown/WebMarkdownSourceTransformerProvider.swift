import FeatherContracts

public struct WebMarkdownSourceTransformerProvider: Event {
    public typealias Output = (any WebMarkdownSourceTransformer)?

    public let request: WebMarkdownSourceTransformerRequest

    public init(request: WebMarkdownSourceTransformerRequest) {
        self.request = request
    }
}
