import FeatherContracts

public enum WebMarkdownEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: WebMarkdownBlockRendererProvider.self,
            context: WebMarkdownBlockRendererRequest.self
        ) { _, _ in
            GridMarkdownBlockRenderer()
        }
        registry.register(
            event: WebMarkdownBlockRendererProvider.self,
            context: WebMarkdownBlockRendererRequest.self
        ) { _, _ in
            CellMarkdownBlockRenderer()
        }
    }
}
