import FeatherOpenAPI

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
}
