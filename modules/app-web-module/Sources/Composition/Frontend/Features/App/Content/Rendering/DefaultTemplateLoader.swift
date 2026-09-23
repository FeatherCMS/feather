import Foundation
import Mustache

public struct DefaultTemplateLoader: TemplateLoader {

    private let paths: [URL]

    public init(paths: [URL]) {
        self.paths = paths
    }

    public func load() throws -> [String: MustacheTemplate] {
        var templates: [String: MustacheTemplate] = [:]
        let fileManager = FileManager.default

        for path in paths {
            guard
                let enumerator = fileManager.enumerator(
                    at: path,
                    includingPropertiesForKeys: nil
                )
            else {
                throw CocoaError(.fileNoSuchFile)
            }

            while let fileURL = enumerator.nextObject() as? URL {
                guard fileURL.pathExtension == "mustache" else { continue }
                let contents = try String(
                    contentsOf: fileURL,
                    encoding: .utf8
                )
                let relativePath = fileURL.path.replacingOccurrences(
                    of: path.path + "/",
                    with: ""
                )
                let templateID = String(
                    relativePath.dropLast(".mustache".count)
                )
                templates[templateID] = try MustacheTemplate(string: contents)
            }
        }

        return templates
    }
}
