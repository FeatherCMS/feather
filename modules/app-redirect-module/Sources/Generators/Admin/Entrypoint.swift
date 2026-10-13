import FeatherOpenAPI
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
        let document = Document()
        let output = getWorkspaceDir()
            .appending(path: "openapi")
        let openAPIDocument = document.openAPIDocument()
        let encoder = YAMLEncoder()

        for version in ["", "@v3_1_0", "@v3_2_0"] {
            let value: String
            switch version {
            case "": value = try encoder.encode(openAPIDocument)
            case "@v3_1_0":
                value = try encoder.encode(openAPIDocument.convert(to: .v3_1_0))
            default:
                value = try encoder.encode(openAPIDocument.convert(to: .v3_2_0))
            }
            try value.write(
                to: output.appending(path: "redirect-admin\(version).yaml"),
                atomically: true,
                encoding: .utf8
            )
        }
    }
}
