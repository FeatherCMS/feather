import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/admin/contact/form": ContactFormPathItems(),
            "api/v1/admin/contact/form/{contactFormKey}":
                ContactFormIDPathItems(),
            "api/v1/admin/contact/field": ContactFieldPathItems(),
            "api/v1/admin/contact/field/{formFieldId}":
                ContactFieldIDPathItems(),
            "api/v1/admin/contact/form/{contactFormKey}/submission":
                ContactFormSubmissionPathItems(),
            "api/v1/admin/contact/form/{contactFormKey}/submission/{contactFormSubmissionId}":
                ContactFormSubmissionIDPathItems(),
        ]
    }
}
