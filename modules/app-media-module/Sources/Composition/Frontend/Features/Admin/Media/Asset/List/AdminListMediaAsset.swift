import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListMediaAsset {
    let controller: any AdminListMediaAssetController

    init(
        apiBuilder: MediaAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminListMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminListMediaAssetDefaultInteractor(
                        repository: AdminListMediaAssetOpenAPIRepository(
                            api: apiBuilder.makeMediaAdmin(context)
                        )
                    ),
                    presenter: AdminListMediaAssetDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
