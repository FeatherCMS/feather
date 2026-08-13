import AccountSharedOpenAPIGenerator
import FeatherOpenAPI
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {
    var pathMap: PathMap {
        [
            "api/v1/account/register": AccountRegisterPathItems(),
            "api/v1/account/invitation/exchange":
                AccountInvitationExchangePathItems(),
            "api/v1/account/settings": AccountSettingsPathItems(),
        ]
    }
}
