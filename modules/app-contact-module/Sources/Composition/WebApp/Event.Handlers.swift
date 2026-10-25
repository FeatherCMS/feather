public import FeatherModuleKit
public import ContactModule
import WebModuleWebApp

public enum Event {
    public enum Handlers {
        public static func registerMarkdown(
            in registry: inout EventRegistry,
            api: API.Client,
            routes: Submission.Router.Routes = .standard,
            turnstileSiteKey: String? = nil
        ) {
            registry.register(
                event: MarkdownBlockRendererProvider.self,
                context: MarkdownBlockRendererRequest.self
            ) { _, _ in
                ContactFormMarkdownBlockRenderer(
                    api: api,
                    routes: routes,
                    turnstileSiteKey: turnstileSiteKey
                )
            }
        }
    }
}
