public import FeatherContracts
import WebFrontend

public enum ContactMarkdownEventHandlers {
    public static func register(
        in registry: inout EventRegistry,
        api: ContactAppAPIClient,
        turnstileSiteKey: String? = nil
    ) {
        registry.register(
            event: WebMarkdownBlockRendererProvider.self,
            context: WebMarkdownBlockRendererRequest.self
        ) { _, _ in
            ContactFormMarkdownBlockRenderer(
                api: api,
                turnstileSiteKey: turnstileSiteKey
            )
        }
    }
}
