import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Form {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/contact/form/{contactFormKey}": Get.PathItem(),
                "api/v1/contact/{contactFormKey}/submissions":
                    Submission.PathItem(),
            ]
        }
    }
}
