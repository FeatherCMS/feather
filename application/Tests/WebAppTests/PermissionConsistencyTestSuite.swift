import Foundation
import FeatherAdmin
import Testing

@testable import WebApp

@Suite
struct PermissionConsistencyTestSuite {

    @Test
    func accountModelCanAccessUsesRawAssignedPermissions() {
        let account = AccountModel(
            user: .init(id: "user_1", email: "admin@example.com"),
            permissions: [
                "account:settings:update",
                "blog:settings:update",
            ],
            roles: []
        )

        #expect(account.canAccess("account:settings:update"))
        #expect(account.canAccess("blog:settings:update"))
        #expect(account.canAccess("account:settings:read") == false)
        #expect(account.canAccess("auth:profile:read") == false)
        #expect(account.canAccess("blog:settings:read") == false)
    }

    @Test
    func frontendUsedPermissionsAreDeclaredInBackend() throws {
        let workspaceRoot = try workspaceRootURL()
        let frontendRoot = workspaceRoot.appendingPathComponent(
            "application/Sources/WebApp",
            isDirectory: true
        )
        let backendRoot = workspaceRoot.appendingPathComponent(
            "modules",
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

private func workspaceRootURL(
    filePath: String = #filePath
) throws -> URL {
    var url = URL(fileURLWithPath: filePath)
    while url.path != "/" {
        let applicationURL = url.appendingPathComponent(
            "application",
            isDirectory: true
        )
        if FileManager.default.fileExists(atPath: applicationURL.path),
            FileManager.default.fileExists(
                atPath:
                    url.appendingPathComponent(
                        "modules",
                        isDirectory: true
                    )
                    .path
            )
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
    return try files.reduce(into: Set<String>()) { result, fileURL in
        let source = try String(contentsOf: fileURL, encoding: .utf8)
        result.formUnion(matches(for: permissionLiteralPattern, in: source))
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
