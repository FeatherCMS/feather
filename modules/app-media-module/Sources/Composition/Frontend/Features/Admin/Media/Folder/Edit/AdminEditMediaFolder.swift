import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditMediaFolder {
    let controller: any AdminEditMediaFolderController

    init(
        apiBuilder: MediaAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminEditMediaFolderDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMediaFolderDefaultInteractor(
                        repository: AdminEditMediaFolderOpenAPIRepository(
                            api: apiBuilder.makeMediaAdmin(context)
                        )
                    ),
                    presenter: AdminEditMediaFolderDefaultPresenter(
                        request: request,
                        context: context,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
