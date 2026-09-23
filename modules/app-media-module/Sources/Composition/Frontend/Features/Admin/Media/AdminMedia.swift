public import FeatherAdmin
import FeatherValidation
import HTML
public import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct AdminMedia {
    private let apiBuilder: MediaAPIBuilder
    private let renderingEngine: any RenderingEngine

    public init(
        apiBuilder: MediaAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.apiBuilder = apiBuilder
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        AdminViewMediaOverview(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListMediaAsset(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddMediaAsset(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddMediaFolder(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminViewMediaAsset(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditMediaAsset(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditMediaFolder(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveMediaAsset(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListMediaVariant(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
            .controller.route(on: router)

        AdminAddMediaVariant(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
            .controller.route(on: router)

        AdminEditMediaVariant(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
            .controller.route(on: router)

        AdminListMediaVariantProcessors(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
            .controller.route(on: router)

        AdminRemoveMediaVariant(
            apiBuilder: apiBuilder,
            renderingEngine: renderingEngine
        )
            .controller.route(on: router)

    }
}
