import FeatherOpenAPI

public struct AuthResponse:
    JSONResponseRepresentable
{
    public var description: String = "Auth response"
    public var schema = AuthResponseSchema().reference()

    public init() {}
}

public struct AuthMeResponse: JSONResponseRepresentable {
    public var description: String = "Auth response"
    public var schema = AuthResponseSchema().reference()

    public init() {}
}
