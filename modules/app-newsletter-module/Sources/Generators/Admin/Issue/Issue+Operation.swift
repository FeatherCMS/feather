import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Issue {
    protocol Operation: Campaign.Operation {}

    protocol IDOperation: Operation {}
}

extension Issue.Operation {
    var parameters: [any ParameterRepresentable] {
        [Campaign.Parameters.Key().reference()]
    }
}

extension Issue.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            Campaign.Parameters.Key().reference(),
            Issue.Parameters.ID().reference(),
        ]
    }
}
