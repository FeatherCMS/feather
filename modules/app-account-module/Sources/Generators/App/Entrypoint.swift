import AccountSharedOpenAPIGenerator
import FeatherOpenAPI
import Foundation
import OpenAPIKit
import OpenAPIKit30
import OpenAPIKitCompat
import Yams

@main
struct Entrypoint {
    private static func workspaceDirectory() -> URL {
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
        let output = workspaceDirectory().appending(path: "openapi")
        let encoder = YAMLEncoder()

        for version in ["", "@v3_1_0", "@v3_2_0"] {
            let value: String
            switch version {
            case "": value = try encoder.encode(document.openAPIDocument())
            case "@v3_1_0":
                value = try encoder.encode(
                    document.openAPIDocument().convert(to: .v3_1_0)
                )
            default:
                value = try encoder.encode(
                    document.openAPIDocument().convert(to: .v3_2_0)
                )
            }
            try value.write(
                to: output.appending(path: "account-app\(version).yaml"),
                atomically: true,
                encoding: .utf8
            )
        }
    }
}
