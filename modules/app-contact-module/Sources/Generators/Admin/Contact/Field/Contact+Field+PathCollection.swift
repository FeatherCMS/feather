import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Field {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/contact/field": PathItem(),
                "api/v1/admin/contact/field/query": Query.PathItem(),
                "api/v1/admin/contact/field/{formFieldId}": ID.PathItem(),
            ]
        }
    }
}
