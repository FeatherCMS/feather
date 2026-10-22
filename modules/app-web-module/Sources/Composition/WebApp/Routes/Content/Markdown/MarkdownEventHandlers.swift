public import FeatherModuleKit

public enum MarkdownEventHandlers {
    public static func register(in registry: inout EventRegistry) {
        registry.register(
            event: MarkdownBlockRendererProvider.self,
            context: MarkdownBlockRendererRequest.self
        ) { _, _ in
            GridMarkdownBlockRenderer()
        }
        registry.register(
            event: MarkdownBlockRendererProvider.self,
            context: MarkdownBlockRendererRequest.self
        ) { _, _ in
            CellMarkdownBlockRenderer()
        }
        registry.register(
            event: MarkdownBlockRendererProvider.self,
            context: MarkdownBlockRendererRequest.self
        ) { _, _ in
            VideoMarkdownBlockRenderer()
        }
    }
}
