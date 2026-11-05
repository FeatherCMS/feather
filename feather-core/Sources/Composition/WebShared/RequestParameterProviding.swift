public import Hummingbird

/// A request context that exposes required route parameter helpers.
public protocol RequestParameterProviding: RequestContext {}

extension RequestParameterProviding {
    public func requiredID() throws -> String {
        try requiredParameter("id")
    }

    public func requiredParameter(
        _ name: String
    ) throws -> String {
        guard
            let value = parameters.get(name, as: String.self),
            !value.isEmpty
        else {
            throw HTTPError(.badRequest)
        }
        return value
    }
}
