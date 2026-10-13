import FeatherOpenAPI
import FeatherOpenAPIGenerator
import Foundation
import OpenAPIKit
import OpenAPIKit30
import OpenAPIKitCompat
import Yams

@main
struct Entrypoint {
    private static func getWorkspaceDir() -> URL {
        if let path = ProcessInfo.processInfo.environment[
            "OPENAPI_WORKSPACE_DIR"
        ] {
            return URL(fileURLWithPath: path, isDirectory: true)
        }
        return URL(
            fileURLWithPath: FileManager.default.currentDirectoryPath,
            isDirectory: true
        )
    }

    static func main() async throws {
        let document = Document().openAPIDocument()
        _ = try document.locallyDereferenced().resolved()

        let outputURL = getWorkspaceDir()
            .appending(path: "openapi/news-admin.yaml")
        let encoder = YAMLEncoder()
        try encoder.encode(document)
            .write(
                to: outputURL,
                atomically: true,
                encoding: .utf8
            )

        let document310 = document.convert(to: .v3_1_0)
        try encoder.encode(document310)
            .write(
                to: getWorkspaceDir()
                    .appending(path: "openapi/news-admin@v3_1_0.yaml"),
                atomically: true,
                encoding: .utf8
            )

        let document320 = document.convert(to: .v3_2_0)
        try encoder.encode(document320)
            .write(
                to: getWorkspaceDir()
                    .appending(path: "openapi/news-admin@v3_2_0.yaml"),
                atomically: true,
                encoding: .utf8
            )
    }
}
