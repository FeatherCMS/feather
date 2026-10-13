public import FeatherContracts

public struct WebMarkdownBlockRendererProvider: Event {
    public typealias Output = (any WebMarkdownBlockRenderer)?

    public init() {}
}
