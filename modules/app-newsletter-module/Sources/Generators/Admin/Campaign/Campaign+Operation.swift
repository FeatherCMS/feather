import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Campaign {
    protocol Operation: BearerProtectedOperation {}

    protocol KeyOperation: Operation {}
}

extension Campaign.Operation {
    var tags: [any TagRepresentable] { [Campaign.Tag()] }
}

extension Campaign.KeyOperation {
    var parameters: [any ParameterRepresentable] {
        [Campaign.Parameters.Key().reference()]
    }
}
