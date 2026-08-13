import FeatherContracts
import WebApplication
import BlogFrontend
import NewsFrontend
import WebApplication
import WebFrontend

func buildWebMetadataExtensions() async throws -> (
    referenceTypes: [WebMetadataReferenceTypeOption],
    templates: [WebPageTemplateOption]
) {
    var events = EventRegistry()
    WebFrontend.WebEventHandlers.register(in: &events)
    BlogFrontend.BlogEventHandlers.register(in: &events)
    NewsFrontend.NewsEventHandlers.register(in: &events)

    let referenceTypeContributions = try await events.trigger(
        event: WebMetadataReferenceTypeOptionProvider(),
        using: WebEventContext()
    )
    let templateContributions = try await events.trigger(
        event: WebPageTemplateOptionProvider(),
        using: WebEventContext()
    )
    return (
        referenceTypes: referenceTypeContributions.flatMap { $0 },
        templates: templateContributions.flatMap { $0 }
    )
}
