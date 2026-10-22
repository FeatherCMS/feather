import FeatherOpenAPI

extension Profile.Put {
    public struct RequestBody: RequestBodyRepresentable {
        public var openAPIIdentifier: String {
            "AccountProfileUpdateRequestBody"
        }
        public var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }

        public init() {}
    }
}
