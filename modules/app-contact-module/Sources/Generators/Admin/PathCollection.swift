import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/admin/contact/form": Contact.Form.PathItem(),
            "api/v1/admin/contact/form/query": Contact.Form.Query.PathItem(),
            "api/v1/admin/contact/submission/query":
                Contact.Submission.Query.PathItem(),
            "api/v1/admin/contact/form/{contactFormKey}":
                Contact.Form.ID.PathItem(),
            "api/v1/admin/contact/field": Contact.Field.PathItem(),
            "api/v1/admin/contact/field/query": Contact.Field.Query.PathItem(),
            "api/v1/admin/contact/field/{formFieldId}":
                Contact.Field.ID.PathItem(),
            "api/v1/admin/contact/form/{contactFormKey}/submission":
                Contact.Submission.PathItem(),
            "api/v1/admin/contact/form/{contactFormKey}/submission/{contactFormSubmissionId}":
                Contact.Submission.ID.PathItem(),
        ]
    }
}
