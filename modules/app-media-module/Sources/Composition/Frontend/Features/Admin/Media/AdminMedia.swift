import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct AdminMedia {
    private let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        AdminViewMediaOverview(
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

        AdminViewMediaAsset(
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

        AdminListMediaVariant(renderingEngine: renderingEngine)
            .controller.route(on: router)

        AdminAddMediaVariant(renderingEngine: renderingEngine)
            .controller.route(on: router)

        AdminEditMediaVariant(renderingEngine: renderingEngine)
            .controller.route(on: router)

        AdminListMediaVariantProcessors(renderingEngine: renderingEngine)
            .controller.route(on: router)

        AdminRemoveMediaVariant(renderingEngine: renderingEngine)
            .controller.route(on: router)

    }
}
