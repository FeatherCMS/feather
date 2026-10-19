public import FeatherModuleKit

public struct WebMarkdownSourceTransformerProvider: Event {
    public typealias Output = (any WebMarkdownSourceTransformer)?

    public init() {}
}
