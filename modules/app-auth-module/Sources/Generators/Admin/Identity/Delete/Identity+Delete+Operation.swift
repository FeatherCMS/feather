import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct UserIdentitySessionRemoveOperation: UserIdentitySessionOperation,
    DeleteOperation
{
    var operationId: String? { "userIdentitySessionRemove" }
}
