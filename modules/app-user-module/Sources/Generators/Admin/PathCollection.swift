import FeatherOpenAPI
import OpenAPIKit30
import UserSharedOpenAPIGenerator

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [
            "api/v1/admin/user/identities": UserIdentityPathItems(),
            "api/v1/admin/user/identities/":
                UserIdentityListPathItems(),
            "api/v1/admin/user/identities/search":
                UserIdentitySearchPathItems(),
            "api/v1/admin/user/identities/{userIdentityId}":
                UserIdentityIdPathItems(),
            "api/v1/admin/user/roles": UserRolePathItems(),
            "api/v1/admin/user/roles/": UserRoleListPathItems(),
            "api/v1/admin/user/roles/search": UserRoleSearchPathItems(),
            "api/v1/admin/user/roles/{userRoleId}": UserRoleIdPathItems(),
        ]
    }
}
