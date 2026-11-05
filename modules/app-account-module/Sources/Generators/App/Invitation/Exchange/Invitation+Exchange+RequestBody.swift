import FeatherOpenAPI

extension Invitation.Exchange {
    public struct RequestBody: RequestBodyRepresentable {
        public var openAPIIdentifier: String {
            "AccountInvitationExchangeRequestBody"
        }
        public var description: String? {
            "Account invitation registration request"
        }
        public var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }

        public init() {}
    }
}
