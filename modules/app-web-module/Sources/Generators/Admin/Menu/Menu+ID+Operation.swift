import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.ID {
    protocol Operation: Menu.Operation {}
}

extension Menu.ID.Operation {
    var parameters: [any ParameterRepresentable] {
        [Menu.Parameters.ID().reference()]
    }
}
