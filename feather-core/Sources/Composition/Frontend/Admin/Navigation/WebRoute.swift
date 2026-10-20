public import Hummingbird

/// A composable route path for browser-based admin interfaces.
///
/// Literal path components and named parameters are kept separate, with
/// conversions for URL strings and Hummingbird route registration.
public struct WebRoute: Hashable, Sendable {
    private enum Component: Hashable, Sendable {
        case literal(String)
        case parameter(String)
    }

    public enum ResolutionError: Error, Equatable, Sendable {
        case missingParameter(String)
    }

    private let components: [Component]

    /// The root route (`/`).
    public static let root = Self(components: [])

    private init(components: [Component]) {
        self.components = components
    }

    /// Returns a route with one literal path component appended.
    public func appending(pathComponent: String) -> Self {
        precondition(
            !pathComponent.isEmpty && !pathComponent.contains("/"),
            "A route path component must be non-empty and cannot contain '/'."
        )
        return Self(components: components + [.literal(pathComponent)])
    }

    /// Returns a route with one named path parameter appended.
    public func appending(parameter name: String) -> Self {
        precondition(
            !name.isEmpty && !name.contains("/") && !name.contains("{")
                && !name.contains("}"),
            "A route parameter must have a valid, non-empty name."
        )
        return Self(components: components + [.parameter(name)])
    }

    /// The route pattern, suitable for registering with a web framework.
    ///
    /// Named parameters are represented as `{name}` components.
    public var pattern: String {
        guard !components.isEmpty else { return "/" }
        return "/"
            + components.map { component in
                switch component {
                case .literal(let value): Self.encodePathComponent(value)
                case .parameter(let name): "{\(name)}"
                }
            }
            .joined(separator: "/")
    }

    /// A string representation of the route pattern.
    public var description: String { pattern }

    /// The framework route value for matching this path pattern.
    public var routerPath: RouterPath { RouterPath(pattern) }

    /// A concrete URL path with a leading and trailing slash.
    public var path: String {
        Self.withTrailingSlash(pattern)
    }

    /// Resolves named parameters into a concrete URL path, encoding each value
    /// as exactly one path component.
    public func path(parameters: [String: String]) throws(ResolutionError)
        -> String
    {
        guard !components.isEmpty else { return "/" }
        var resolved: [String] = []
        for component in components {
            switch component {
            case .literal(let value):
                resolved.append(Self.encodePathComponent(value))
            case .parameter(let name):
                guard let value = parameters[name] else {
                    throw ResolutionError.missingParameter(name)
                }
                resolved.append(Self.encodePathComponent(value))
            }
        }
        return Self.withTrailingSlash("/" + resolved.joined(separator: "/"))
    }

    /// Resolves a route containing exactly one named parameter.
    public func path(parameter name: String, value: String) -> String {
        var didResolveParameter = false
        let resolved = components.map { component -> String in
            switch component {
            case .literal(let value):
                return Self.encodePathComponent(value)
            case .parameter(let parameter):
                precondition(
                    parameter == name && !didResolveParameter,
                    "This overload requires exactly one matching route parameter."
                )
                didResolveParameter = true
                return Self.encodePathComponent(value)
            }
        }
        precondition(
            didResolveParameter,
            "The route does not contain the named parameter."
        )
        return Self.withTrailingSlash("/" + resolved.joined(separator: "/"))
    }

    private static func withTrailingSlash(_ path: String) -> String {
        path == "/" || path.hasSuffix("/") ? path : path + "/"
    }

    private static func encodePathComponent(_ value: String) -> String {
        let hexadecimal = Array("0123456789ABCDEF".utf8)
        var encoded: [UInt8] = []
        for byte in value.utf8 {
            switch byte {
            case 65...90, 97...122, 48...57, 45, 46, 95, 126:
                encoded.append(byte)
            default:
                encoded.append(37)
                encoded.append(hexadecimal[Int(byte >> 4)])
                encoded.append(hexadecimal[Int(byte & 0x0F)])
            }
        }
        return String(decoding: encoded, as: UTF8.self)
    }
}
