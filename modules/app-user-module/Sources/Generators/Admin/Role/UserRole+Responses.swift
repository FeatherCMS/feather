import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct UserRoleDetailResponse: JSONResponseRepresentable {
    var description: String = "UserRole response"
    var schema = Role.Get.Schema().reference()
}
