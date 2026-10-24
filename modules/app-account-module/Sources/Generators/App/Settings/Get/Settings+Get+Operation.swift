import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings.Get {
    struct Operation: OperationRepresentable, BearerProtectedOperation {
        var operationId: String? { "accountSettingsGet" }
        var tags: [any TagRepresentable] { [Account.Tag()] }
        var responseMap: ResponseMap {
            [200: Settings.Response().reference()]
        }
    }
}
