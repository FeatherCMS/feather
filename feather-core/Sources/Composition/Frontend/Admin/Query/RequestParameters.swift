public import Hummingbird

extension Request {
    public func requiredID() throws -> String {
        try requiredParameter("id")
    }

    public func requiredParameter(
        _ name: String
    ) throws -> String {
        guard
            let value = uri.queryParameters.get(name, as: String.self),
            !value.isEmpty
        else {
            throw HTTPError(.badRequest)
        }
        return value
    }
}
