import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

public struct AdminMedia {
    private let renderingEngine: any RenderingEngine

    public init(renderingEngine: any RenderingEngine) {
        self.renderingEngine = renderingEngine
    }


    public func route(
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
