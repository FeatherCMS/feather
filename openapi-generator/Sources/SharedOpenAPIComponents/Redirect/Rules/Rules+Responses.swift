import FeatherOpenAPI

public struct RedirectRuleResponse: JSONResponseRepresentable {
    public var description: String = "Redirect rule response"
    public var schema = RedirectRuleSchema().reference()

    public init() {}
}
