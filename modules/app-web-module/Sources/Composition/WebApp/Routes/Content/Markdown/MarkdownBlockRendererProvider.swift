public import FeatherModuleKit

public struct MarkdownBlockRendererProvider: FeatherModuleKit.Event<
    (any MarkdownBlockRenderer)?
> {
    public init() {}
}
