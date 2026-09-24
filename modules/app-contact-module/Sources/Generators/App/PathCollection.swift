import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/contact/form/{contactFormKey}":
                AppContactFormGetPathItems(),
            "api/v1/contact/form/{contactFormKey}/submit":
                AppContactFormSubmissionPathItems(),
        ]
    }
}
