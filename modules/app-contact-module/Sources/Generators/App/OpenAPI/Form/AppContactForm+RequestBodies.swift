import FeatherOpenAPI
import OpenAPIKit30

struct AppContactFormSubmissionRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AppContactFormSubmissionSchema().reference())]
    }
}
