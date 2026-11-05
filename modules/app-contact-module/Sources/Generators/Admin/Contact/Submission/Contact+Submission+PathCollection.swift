import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Submission {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/contact/submission/query": Query.PathItem(),
                "api/v1/admin/contact/form/{contactFormKey}/submission":
                    PathItem(),
                "api/v1/admin/contact/form/{contactFormKey}/submission/{contactFormSubmissionId}":
                    ID.PathItem(),
            ]
        }
    }
}
