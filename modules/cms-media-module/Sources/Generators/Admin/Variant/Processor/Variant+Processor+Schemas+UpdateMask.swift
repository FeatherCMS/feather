import FeatherOpenAPI

extension Variant.Processor {
    enum Schemas {}
}

extension Variant.Processor.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String {
            "MediaVariantProcessorUpdateMaskField"
        }
        var example: String? = "name,matchExtensions,commandTemplate,isActive"
    }
}
