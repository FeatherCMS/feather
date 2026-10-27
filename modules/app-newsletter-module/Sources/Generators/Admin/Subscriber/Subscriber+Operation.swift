import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Subscriber {
    protocol Operation: Campaign.Operation {}

    protocol IDOperation: Operation {}
}

extension Subscriber.Operation {
    var parameters: [any ParameterRepresentable] {
        [Campaign.Parameters.ID().reference()]
    }
}

extension Subscriber.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            Campaign.Parameters.ID().reference(),
            Subscriber.Parameters.Email().reference(),
        ]
    }
}
