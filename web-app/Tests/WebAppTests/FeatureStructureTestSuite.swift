import Foundation
import Testing

@Suite
struct FeatureStructureTestSuite {

    @Test
    func featureModulesHaveExpectedStructure() throws {
        let fileManager = FileManager.default
        let featureModules = try moduleDirectories(fileManager: fileManager)

        #expect(featureModules.isEmpty == false)

        let failures = try featureModules.flatMap { moduleURL in
            try validate(moduleURL: moduleURL, fileManager: fileManager)
        }

        if failures.isEmpty == false {
            Issue.record(
                """
                Feature structure mismatches:
                \(failures.joined(separator: "\n"))
                """
            )
        }

        #expect(failures.isEmpty)
    }

    private func moduleDirectories(
        fileManager: FileManager
    ) throws -> [URL] {
        let featureRoot = featuresRootURL()
        let enumerator = fileManager.enumerator(
            at: featureRoot,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        var modules: [URL] = []

        while let next = enumerator?.nextObject() as? URL {
            let values = try next.resourceValues(forKeys: [.isDirectoryKey])
            guard values.isDirectory == true else {
                continue
            }

            let children = try Set(
                fileManager.contentsOfDirectory(atPath: next.path)
            )
            let requiredDirectories: Set<String> = [
                "Abstraction",
                "Implementation",
                "Models",
            ]

            if requiredDirectories.isSubset(of: children) {
                modules.append(next)
            }
        }

        return modules.sorted { $0.path < $1.path }
    }

    private func validate(
        moduleURL: URL,
        fileManager: FileManager
    ) throws -> [String] {
        let relativePath = moduleURL.path.replacingOccurrences(
            of: featuresRootURL().path + "/",
            with: ""
        )

        let rootSwiftFiles = try swiftFileNames(
            in: moduleURL,
            fileManager: fileManager
        )

        let abstractionURL = moduleURL.appendingPathComponent(
            "Abstraction",
            isDirectory: true
        )
        let implementationURL = moduleURL.appendingPathComponent(
            "Implementation",
            isDirectory: true
        )

        let abstractionFiles = try swiftFileNames(
            in: abstractionURL,
            fileManager: fileManager
        )
        let implementationFiles = try swiftFileNames(
            in: implementationURL,
            fileManager: fileManager
        )

        var failures: [String] = []

        for role in ["Controller", "Interactor", "Presenter"] {
            let protocolFiles = abstractionFiles.filter {
                $0.hasSuffix(role)
            }
            let implementationRole = "Default\(role)"
            let implementationRoleFiles = implementationFiles.filter {
                $0.hasSuffix(implementationRole)
            }

            if protocolFiles.count != 1 {
                failures.append(
                    "\(relativePath): expected exactly 1 abstraction \(role) file, found \(protocolFiles.count)"
                )
                continue
            }

            if implementationRoleFiles.count != 1 {
                failures.append(
                    "\(relativePath): expected exactly 1 implementation \(implementationRole) file, found \(implementationRoleFiles.count)"
                )
                continue
            }

            let prefix = String(protocolFiles[0].dropLast(role.count))
            let expectedImplementation = "\(prefix)\(implementationRole)"
            let expectedAssembly = "\(prefix)"

            if implementationRoleFiles[0] != expectedImplementation {
                failures.append(
                    "\(relativePath): expected \(expectedImplementation).swift in Implementation"
                )
            }

            if rootSwiftFiles.contains(expectedAssembly) == false {
                failures.append(
                    "\(relativePath): missing assembly file \(expectedAssembly).swift"
                )
            }
        }

        return failures
    }

    private func swiftFileNames(
        in directoryURL: URL,
        fileManager: FileManager
    ) throws -> [String] {
        try fileManager.contentsOfDirectory(
            at: directoryURL,
            includingPropertiesForKeys: nil
        )
        .filter { $0.pathExtension == "swift" }
        .map { $0.deletingPathExtension().lastPathComponent }
        .sorted()
    }

    private func featuresRootURL() -> URL {
        URL(filePath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appending(path: "Sources/WebApp/Features")
    }
}
