import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Processor {
    protocol Operation: Variant.IDOperation {}
    protocol IDOperation: Operation {}
}

extension Variant.Processor.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            Variant.Parameters.ID().reference(),
            Variant.Processor.Parameters.ID().reference(),
        ]
    }
}
