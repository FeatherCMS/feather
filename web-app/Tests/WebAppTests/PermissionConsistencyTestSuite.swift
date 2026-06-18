import Foundation
import Testing

@testable import WebApp

@Suite
struct PermissionConsistencyTestSuite {

    @Test
    func accountModelCanAccessUsesRawAssignedPermissions() {
        let account = AccountModel(
            user: .init(id: "user_1", email: "admin@example.com"),
            permissions: [
                "auth:settings:update",
                "blog:settings:update",
            ],
            roles: []
        )

        #expect(account.canAccess("auth:settings:update"))
        #expect(account.canAccess("blog:settings:update"))
        #expect(account.canAccess("auth:settings:read") == false)
        #expect(account.canAccess("auth:profile:read") == false)
        #expect(account.canAccess("blog:settings:read") == false)
    }

    @Test
    func frontendUsedPermissionsAreDeclaredInBackend() throws {
        let workspaceRoot = try workspaceRootURL()
        let frontendRoot = workspaceRoot.appendingPathComponent(
            "web-app/Sources/WebApp",
            isDirectory: true
        )
        let backendRoot = workspaceRoot.appendingPathComponent(
            "backend/app-modules",
            isDirectory: true
        )

        let frontendFiles = try swiftFiles(in: frontendRoot)
        let backendFiles = try swiftFiles(in: backendRoot)
            .filter {
                $0.lastPathComponent.hasSuffix("Permissions.swift")
            }

        let frontendPermissions = try frontendUsedPermissions(in: frontendFiles)
        let backendPermissions = try declaredBackendPermissions(
            in: backendFiles
        )
        let missing = frontendPermissions.subtracting(backendPermissions)
            .sorted()

        #expect(
            missing.isEmpty,
            "Frontend uses permissions that are not declared by backend providers: \(missing.joined(separator: ", "))"
        )
    }
}

private let permissionLiteralPattern =
    #""([a-z][a-z0-9-]*:[a-z][a-z0-9-]*:[a-z][a-z0-9-]*)""#

private let scopeDefinitionPattern =
    #"static\s+let\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*PermissionScope\s*\(\s*module:\s*"([a-z0-9-]+)"\s*,\s*resource:\s*"([a-z0-9-]+)""#

private let directScopeAccessPattern =
    #"([A-Za-z_][A-Za-z0-9_]*\.Scope\.[A-Za-z_][A-Za-z0-9_]*)\.(create|read|update|list|delete|canCreate|canRead|canUpdate|canList|canDelete)\b"#

private let scopeAliasPattern =
    #"(?:^|\s)(?:private\s+)?(?:fileprivate\s+)?(?:static\s+)?(?:let|var)\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*([A-Za-z_][A-Za-z0-9_]*\.Scope\.[A-Za-z_][A-Za-z0-9_]*)\b"#

private let aliasedScopeAccessPattern =
    #"\b([A-Za-z_][A-Za-z0-9_]*)\.(create|read|update|list|delete|canCreate|canRead|canUpdate|canList|canDelete)\b"#

private func workspaceRootURL(
    filePath: String = #filePath
) throws -> URL {
    var url = URL(fileURLWithPath: filePath)
    while url.path != "/" {
        let backendURL = url.appendingPathComponent(
            "backend",
            isDirectory: true
        )
        let webAppURL = url.appendingPathComponent("web-app", isDirectory: true)
        let openAPIURL = url.appendingPathComponent(
            "openapi",
            isDirectory: true
        )
        if FileManager.default.fileExists(atPath: backendURL.path),
            FileManager.default.fileExists(atPath: webAppURL.path),
            FileManager.default.fileExists(atPath: openAPIURL.path)
        {
            return url
        }
        url.deleteLastPathComponent()
    }
    throw TestFailure("Unable to locate workspace root from \(filePath)")
}

private func swiftFiles(
    in root: URL
) throws -> [URL] {
    guard
        let enumerator = FileManager.default.enumerator(
            at: root,
            includingPropertiesForKeys: nil
        )
    else {
        throw TestFailure("Unable to enumerate \(root.path)")
    }
    return enumerator.compactMap { element in
        guard let fileURL = element as? URL else {
            return nil
        }
        guard fileURL.pathExtension == "swift" else {
            return nil
        }
        return fileURL
    }
}

private func declaredBackendPermissions(
    in files: [URL]
) throws -> Set<String> {
    try files.reduce(into: Set<String>()) { result, fileURL in
        let source = try String(contentsOf: fileURL, encoding: .utf8)
        result.formUnion(matches(for: permissionLiteralPattern, in: source))
    }
}

private func frontendUsedPermissions(
    in files: [URL]
) throws -> Set<String> {
    let scopeDefinitions = try scopeDefinitions(in: files)

    return try files.reduce(into: Set<String>()) { result, fileURL in
        let source = try String(contentsOf: fileURL, encoding: .utf8)
        result.formUnion(matches(for: permissionLiteralPattern, in: source))

        for match in regexMatches(for: directScopeAccessPattern, in: source) {
            guard
                let scopeReference = match.capture(at: 1, in: source),
                let actionToken = match.capture(at: 2, in: source),
                let permission = resolvePermission(
                    scopeReference: scopeReference,
                    actionToken: actionToken,
                    scopeDefinitions: scopeDefinitions
                )
            else {
                continue
            }
            result.insert(permission)
        }

        let scopeAliases: [String: String] = Dictionary(
            uniqueKeysWithValues: regexMatches(
                for: scopeAliasPattern,
                in: source
            )
            .compactMap { match in
                guard
                    let alias = match.capture(at: 1, in: source),
                    let scopeReference = match.capture(at: 2, in: source)
                else {
                    return nil
                }
                return (alias, scopeReference)
            }
        )

        for match in regexMatches(for: aliasedScopeAccessPattern, in: source) {
            guard
                let alias = match.capture(at: 1, in: source),
                let scopeReference = scopeAliases[alias],
                let actionToken = match.capture(at: 2, in: source),
                let permission = resolvePermission(
                    scopeReference: scopeReference,
                    actionToken: actionToken,
                    scopeDefinitions: scopeDefinitions
                )
            else {
                continue
            }
            result.insert(permission)
        }
    }
}

private func scopeDefinitions(
    in files: [URL]
) throws -> [String: (module: String, resource: String)] {
    try files.reduce(into: [:]) { result, fileURL in
        let source = try String(contentsOf: fileURL, encoding: .utf8)
        guard
            let typeName = regexMatches(
                for: #"struct\s+([A-Za-z_][A-Za-z0-9_]*)"#,
                in: source
            )
            .first?
            .capture(at: 1, in: source)
        else {
            return
        }
        for match in regexMatches(for: scopeDefinitionPattern, in: source) {
            guard
                let scopeName = match.capture(at: 1, in: source),
                let module = match.capture(at: 2, in: source),
                let resource = match.capture(at: 3, in: source)
            else {
                continue
            }
            result["\(typeName).Scope.\(scopeName)"] = (module, resource)
        }
    }
}

private func resolvePermission(
    scopeReference: String,
    actionToken: String,
    scopeDefinitions: [String: (module: String, resource: String)]
) -> String? {
    guard let scope = scopeDefinitions[scopeReference] else {
        return nil
    }
    let action = normalizedAction(from: actionToken)
    return "\(scope.module):\(scope.resource):\(action)"
}

private func normalizedAction(
    from token: String
) -> String {
    switch token {
    case "canCreate":
        return "create"
    case "canRead":
        return "read"
    case "canUpdate":
        return "update"
    case "canList":
        return "list"
    case "canDelete":
        return "delete"
    default:
        return token
    }
}

private func matches(
    for pattern: String,
    in source: String
) -> Set<String> {
    Set(
        regexMatches(for: pattern, in: source)
            .compactMap {
                $0.capture(at: 1, in: source)
            }
    )
}

private func regexMatches(
    for pattern: String,
    in source: String
) -> [NSTextCheckingResult] {
    let expression = try? NSRegularExpression(
        pattern: pattern,
        options: [.anchorsMatchLines]
    )
    let range = NSRange(source.startIndex..<source.endIndex, in: source)
    return expression?.matches(in: source, options: [], range: range) ?? []
}

extension NSTextCheckingResult {
    fileprivate func capture(
        at index: Int,
        in source: String
    ) -> String? {
        guard index < numberOfRanges else {
            return nil
        }
        let range = range(at: index)
        guard
            range.location != NSNotFound,
            let swiftRange = Range(range, in: source)
        else {
            return nil
        }
        return String(source[swiftRange])
    }
}

private struct TestFailure: Error, CustomStringConvertible {
    let description: String

    init(_ description: String) {
        self.description = description
    }
}
