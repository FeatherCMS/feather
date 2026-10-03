public import FeatherContracts
public import WebFrontend

public enum ContactMarkdownEventHandlers {
    public static func register(
        in registry: inout EventRegistry,
        api: ContactAppAPIClient,
        formChallengeProvider: (any WebFormChallengeProvider)? = nil
    ) {
        registry.register(
            event: WebMarkdownBlockRendererProvider.self,
            context: WebMarkdownBlockRendererRequest.self
        ) { _, _ in
            ContactFormMarkdownBlockRenderer(
                api: api,
                formChallengeProvider: formChallengeProvider
            )
        }
    }
}
