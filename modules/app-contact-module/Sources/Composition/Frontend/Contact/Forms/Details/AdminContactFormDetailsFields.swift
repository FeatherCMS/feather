import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminContactFormDetailsFields {
    let renderingEngine: any RenderingEngine

    func route(on router: Router<AppRequestContext>) {
        AdminListContactFormFields(renderingEngine: renderingEngine)
            .route(on: router)
        AdminAddContactFormField(renderingEngine: renderingEngine)
            .route(on: router)
        AdminEditContactFormField(renderingEngine: renderingEngine)
            .route(on: router)
        AdminRemoveContactFormField(renderingEngine: renderingEngine)
            .route(on: router)
    }
}
