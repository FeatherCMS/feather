public import FeatherModuleKit

extension Event.Handlers {
    public static func registerMarkdown(in registry: inout EventRegistry) {
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
