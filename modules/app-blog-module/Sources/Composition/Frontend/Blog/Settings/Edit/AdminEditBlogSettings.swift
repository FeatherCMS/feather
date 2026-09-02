import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebStandards

struct AdminEditBlogSettings {
    let controller: any AdminEditBlogSettingsController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminEditBlogSettingsDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminEditBlogSettingsDefaultInteractor(
                        repository: AdminEditBlogSettingsOpenAPIRepository(
                            api: context.blogAdminAPI()
                        )
                    ),
                    presenter: AdminEditBlogSettingsDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }
}
