import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Campaign {
    protocol Operation: BearerProtectedOperation {}

    protocol IDOperation: Operation {}
}

extension Campaign.Operation {
    var tags: [any TagRepresentable] { [Campaign.Tag()] }
}

extension Campaign.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [Campaign.Parameters.ID().reference()]
    }
}
