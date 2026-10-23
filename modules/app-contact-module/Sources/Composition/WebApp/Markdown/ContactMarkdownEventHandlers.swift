public import FeatherModuleKit
import WebModuleWebApp

public enum ContactMarkdownEventHandlers {
    public static func register(
        in registry: inout EventRegistry,
        api: API.Client,
        turnstileSiteKey: String? = nil
    ) {
        registry.register(
            event: MarkdownBlockRendererProvider.self,
            context: MarkdownBlockRendererRequest.self
        ) { _, _ in
            ContactFormMarkdownBlockRenderer(
                api: api,
                turnstileSiteKey: turnstileSiteKey
            )
        }
    }
}
