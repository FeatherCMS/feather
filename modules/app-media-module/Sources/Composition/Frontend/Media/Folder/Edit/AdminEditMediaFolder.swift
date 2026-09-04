import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditMediaFolder {
    let controller: any AdminEditMediaFolderController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditMediaFolderDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditMediaFolderDefaultInteractor(
                        repository: AdminEditMediaFolderOpenAPIRepository(
                            api: context.mediaAdminAPI()
                        )
                    ),
                    presenter: AdminEditMediaFolderDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
