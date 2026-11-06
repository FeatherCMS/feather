import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.Validate {
    struct Operation: OperationRepresentable {
        var operationId: String? { "accountInvitationValidate" }
        var tags: [any TagRepresentable] { [Account.Tag()] }
        var parameters: [any ParameterRepresentable] {
            [TokenParameter().reference()]
        }
        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
