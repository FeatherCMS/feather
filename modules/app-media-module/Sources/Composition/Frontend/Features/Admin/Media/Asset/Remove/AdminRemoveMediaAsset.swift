import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveMediaAsset {
    let controller: any AdminRemoveMediaAssetController

    init(
        apiBuilder: MediaAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminRemoveMediaAssetDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminRemoveMediaAssetDefaultInteractor(
                        repository: AdminRemoveMediaAssetOpenAPIRepository(
                            api: apiBuilder.makeMediaAdmin(context)
                        )
                    ),
                    presenter: AdminRemoveMediaAssetDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
