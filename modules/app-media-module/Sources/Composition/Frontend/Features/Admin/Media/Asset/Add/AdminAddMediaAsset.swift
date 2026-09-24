import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddMediaAsset {
    let controller: any AdminAddMediaAssetController

    init(
        apiBuilder: MediaAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminAddMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddMediaAssetDefaultInteractor(
                        repository: AdminAddMediaAssetOpenAPIRepository(
                            api: apiBuilder.makeMediaAdmin(context)
                        )
                    ),
                    presenter: AdminAddMediaAssetDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
