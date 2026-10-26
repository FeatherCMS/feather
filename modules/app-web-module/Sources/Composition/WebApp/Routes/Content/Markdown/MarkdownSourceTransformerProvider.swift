public import FeatherModuleKit

public struct MarkdownSourceTransformerProvider: FeatherModuleKit.Event<
    (any MarkdownSourceTransformer)?
> {
    public init() {}
}
