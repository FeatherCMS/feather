public import FeatherModuleKit

public struct WebMarkdownBlockRendererProvider: Event {
    public typealias Output = (any WebMarkdownBlockRenderer)?

    public init() {}
}
