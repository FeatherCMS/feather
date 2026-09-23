public import FeatherContracts

public struct WebMarkdownSourceTransformerProvider: Event {
    public typealias Output = (any WebMarkdownSourceTransformer)?

    public init() {}
}
