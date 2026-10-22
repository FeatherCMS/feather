public import FeatherModuleKit

public struct MarkdownSourceTransformerProvider: Event {
    public typealias Output = (any MarkdownSourceTransformer)?

    public init() {}
}
