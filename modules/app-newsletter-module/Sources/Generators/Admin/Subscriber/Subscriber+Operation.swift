import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Subscriber {
    protocol Operation: Campaign.Operation {}

    protocol IDOperation: Operation {}
}

extension Subscriber.Operation {
    var parameters: [any ParameterRepresentable] {
        [Campaign.Parameters.Key().reference()]
    }
}

extension Subscriber.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            Campaign.Parameters.Key().reference(),
            Subscriber.Parameters.Email().reference(),
        ]
    }
}
