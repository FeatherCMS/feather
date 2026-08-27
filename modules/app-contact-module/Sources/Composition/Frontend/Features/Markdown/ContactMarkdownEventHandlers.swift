import ContactAppAPI
import FeatherContracts
import WebFrontend

public enum ContactMarkdownEventHandlers {
    public static func register(
        in registry: inout EventRegistry,
        api: ContactAppAPIClient
    ) {
        registry.register(
            event: WebMarkdownBlockRendererProvider.self,
            context: WebMarkdownBlockRendererRequest.self
        ) { _, _ in
            ContactFormMarkdownBlockRenderer(api: api)
        }
    }
}
