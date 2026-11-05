import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Form {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/contact/form": PathItem(),
                "api/v1/admin/contact/form/query": Query.PathItem(),
                "api/v1/admin/contact/form/{contactFormKey}": ID.PathItem(),
            ]
        }
    }
}
