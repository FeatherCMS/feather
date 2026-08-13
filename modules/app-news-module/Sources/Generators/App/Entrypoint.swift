import FeatherOpenAPI
import FeatherOpenAPIGenerator
import Foundation
import NewsSharedOpenAPIGenerator
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

    private static func getOpenAPIOutputDir() -> URL {
        getWorkspaceDir()
            .appending(path: "openapi")
    }

    static func main() async throws {
        let document = Document()

        let basename = "news-app"
        let openapiOutputURL = getOpenAPIOutputDir()
        let encoder = YAMLEncoder()
        let openAPIDoc = document.openAPIDocument()
        _ = try openAPIDoc.locallyDereferenced().resolved()

        let v300YAMLFileURL = openapiOutputURL.appending(
            path: "\(basename).yaml"
        )
        let v310YAMLFileURL = openapiOutputURL.appending(
            path: "\(basename)@v3_1_0.yaml"
        )
        let v320YAMLFileURL = openapiOutputURL.appending(
            path: "\(basename)@v3_2_0.yaml"
        )

        let result300 = try encoder.encode(openAPIDoc)
        try result300.write(
            to: v300YAMLFileURL,
            atomically: true,
            encoding: .utf8
        )

        let doc310 = openAPIDoc.convert(to: .v3_1_0)
        let result310 = try encoder.encode(doc310)
        try result310.write(
            to: v310YAMLFileURL,
            atomically: true,
            encoding: .utf8
        )

        let doc320 = openAPIDoc.convert(to: .v3_2_0)
        let result320 = try encoder.encode(doc320)
        try result320.write(
            to: v320YAMLFileURL,
            atomically: true,
            encoding: .utf8
        )
    }
}
