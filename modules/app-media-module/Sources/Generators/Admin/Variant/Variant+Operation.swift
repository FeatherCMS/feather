import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant {
    protocol Operation: BearerProtectedOperation {}
    protocol IDOperation: Operation {}
}

extension Variant.Operation {
    var tags: [any TagRepresentable] { [MediaVariantTag()] }
}

extension Variant.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [MediaVariantIdParameter().reference()]
    }
}

extension Variant.Processor {
    protocol Operation: Variant.IDOperation {}
    protocol IDOperation: Operation {}
}

extension Variant.Processor.IDOperation {
    var parameters: [any ParameterRepresentable] {
        [
            MediaVariantIdParameter().reference(),
            MediaVariantProcessorIdParameter().reference(),
        ]
    }
}
