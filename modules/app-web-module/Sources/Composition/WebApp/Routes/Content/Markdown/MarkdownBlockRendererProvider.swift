public import FeatherModuleKit

public struct MarkdownBlockRendererProvider: Event {
    public typealias Output = (any MarkdownBlockRenderer)?

    public init() {}
}
