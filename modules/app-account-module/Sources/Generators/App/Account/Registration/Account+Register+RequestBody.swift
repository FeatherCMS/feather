import FeatherOpenAPI

extension Account.Register {
    public struct RequestBody: RequestBodyRepresentable {
        public var openAPIIdentifier: String { "AccountRegisterRequestBody" }
        public var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }

        public init() {}
    }
}
