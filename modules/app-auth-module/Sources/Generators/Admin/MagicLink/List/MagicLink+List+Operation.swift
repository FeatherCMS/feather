import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension MagicLink.List {

    struct Operation: MagicLink.Operation {
        var operationId: String? { "authMagicLinkList" }

        var responseMap: ResponseMap {
            [200: MagicLink.List.Response().reference()]
        }
    }
}
