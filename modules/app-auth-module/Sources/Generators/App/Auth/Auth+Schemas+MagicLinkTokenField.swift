import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Auth.Schemas {
    struct MagicLinkTokenField: StringSchemaRepresentable {
        var example: String? = "mgl_3XbY..."
    }
}
