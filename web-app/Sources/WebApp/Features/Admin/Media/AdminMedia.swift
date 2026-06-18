import Hummingbird

struct AdminMedia {
    let renderingEngine: any RenderingEngine

    enum Scope {
        static let assets = PermissionScope(
            module: "media",
            resource: "assets"
        )
        static let processors = PermissionScope(
            module: "media",
            resource: "processors"
        )
    }

    func route(
        on router: Router<AppRequestContext>
    ) {
        AdminGetMediaHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListMediaAsset(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddMediaAsset(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddMediaFolder(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetMediaAsset(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditMediaAsset(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditMediaFolder(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveMediaAsset(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListMediaProcessors(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddMediaProcessor(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetMediaProcessor(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditMediaProcessor(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveMediaProcessor(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
