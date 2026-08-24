import FeatherAdmin
import Hummingbird
import WebContracts

enum AdminWebPageMetadataRoutes {
    static func register(
        router: Router<AppRequestContext>,
        renderingEngine: any RenderingEngine,
        templateOptions: [WebPageTemplateOption]
    ) {
        let handler = AdminWebMetadataEditHandler(
            renderingEngine: renderingEngine,
            templateOptions: templateOptions
        )
        let path = "/admin/web/pages/{id}/edit/metadata/{metadataID}/"
        router.get(RouterPath(path)) { request, context in
            try await handler.get(
                request: request,
                context: context,
                referenceType: "web.page"
            )
        }
        router.post(RouterPath(path)) { request, context in
            try await handler.post(
                request: request,
                context: context,
                referenceType: "web.page"
            )
        }
    }
}
