import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogSettings {
    protocol Operation: BearerProtectedOperation {}
}

extension BlogSettings.Operation {
    var tags: [any TagRepresentable] { [BlogSettingsTag()] }
}
