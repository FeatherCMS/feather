import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Issue {
    protocol Operation: Campaign.Operation {}

    protocol IDOperation: Operation {}
}

extension Issue.Operation {
    var parameters: [any ParameterRepresentable] {
        [Campaign.Parameters.ID().reference()]
    }
}

extension Issue.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            Campaign.Parameters.ID().reference(),
            Issue.Parameters.ID().reference(),
        ]
    }
}
