import FeatherOpenAPI

extension Variant.Processor.ID {
    struct PathItem: PathItemRepresentable {
        var get: (any OperationRepresentable)? {
            Variant.Processor.Get.Operation()
        }
        var patch: (any OperationRepresentable)? {
            Variant.Processor.Patch.Operation()
        }
    }
}
