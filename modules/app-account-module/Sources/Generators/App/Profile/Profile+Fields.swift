import FeatherOpenAPI
import OpenAPIKit30

extension Profile.Fields {
    public struct Name: SchemaRepresentable {
        public var required: Bool

        public init(required: Bool = true) {
            self.required = required
        }

        public func openAPISchema() -> JSONSchema {
            .string(required: required, nullable: true)
        }
    }

    public struct ImageAssetID: SchemaRepresentable {
        public var required: Bool

        public init(required: Bool = true) {
            self.required = required
        }

        public func openAPISchema() -> JSONSchema {
            .string(required: required, nullable: true)
        }
    }
}
