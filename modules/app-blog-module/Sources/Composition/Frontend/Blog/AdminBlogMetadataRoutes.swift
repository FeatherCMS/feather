import FeatherAdmin
import FeatherContracts
import Hummingbird
import WebContracts
import WebFrontend

enum AdminBlogMetadataRoutes {
    private struct AdminBlogMetadataDefaultInteractor {
        let events: any EventPublisher

        func getTemplateOptions() async throws -> [WebPageTemplateOption] {
            let providers = try await events.trigger(
                event: WebTemplateProviderEvent(),
                using: WebEventContext()
            )
            return providers
                .flatMap(\.templates)
                .map { .init(value: $0.id, title: $0.title) }
        }
    }

    static func register(
        router: Router<DefaultRequestContext>,
        renderingEngine: any RenderingEngine,
        events: any EventPublisher
    ) {
        let interactor = AdminBlogMetadataDefaultInteractor(events: events)
        for route in [
            (
                "/admin/blog/posts/{id}/edit/metadata/{metadataID}/",
                "blog.post"
            ),
            (
                "/admin/blog/authors/{id}/edit/metadata/{metadataID}/",
                "blog.author"
            ),
            (
                "/admin/blog/tags/{id}/edit/metadata/{metadataID}/",
                "blog.tag"
            ),
        ] {
            router.get(RouterPath(route.0)) { request, context in
                let handler = AdminWebMetadataEditHandler(
                    renderingEngine: renderingEngine,
                    templateOptions: try await interactor.getTemplateOptions()
                )
                return try await handler.get(
                    request: request,
                    context: context,
                    referenceType: route.1
                )
            }
            router.post(RouterPath(route.0)) { request, context in
                let handler = AdminWebMetadataEditHandler(
                    renderingEngine: renderingEngine,
                    templateOptions: try await interactor.getTemplateOptions()
                )
                return try await handler.post(
                    request: request,
                    context: context,
                    referenceType: route.1
                )
            }
        }
    }
}
