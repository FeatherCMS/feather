public import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Metadata {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/web/metadata": PathItem(),
                "api/v1/admin/web/metadata/query": Query.PathItem(),
                "api/v1/admin/web/metadata/resolve": Resolve.PathItem(),
                "api/v1/admin/web/metadata/{metadataId}":
                    ID.PathItem(),
            ]
        }
    }
}
