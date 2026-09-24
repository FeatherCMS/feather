public import Foundation
public import Mustache

public struct DefaultTemplateLoader: TemplateLoader {

    private let paths: [URL]

    public init(paths: [URL]) {
        self.paths = paths
    }

    public func load() throws -> [String: MustacheTemplate] {
        try loadSources().reduce(into: [:]) { templates, source in
            templates[source.id] = try MustacheTemplate(string: source.body)
        }
    }

    public func loadMetadata() throws -> [String: TemplateMetadata] {
        try loadSources().reduce(into: [:]) { metadata, source in
            metadata[source.id] = source.metadata
        }
    }

    private func loadSources() throws -> [LoadedTemplateSource] {
        var sources: [LoadedTemplateSource] = []
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
                let parsed = try parseFrontMatter(contents)
                sources.append(
                    .init(
                        id: templateID,
                        body: parsed.body,
                        metadata: parsed.metadata
                    )
                )
            }
        }

        return sources
    }
}

private struct LoadedTemplateSource {

    let id: String
    let body: String
    let metadata: TemplateMetadata
}

private struct ParsedTemplateSource {

    let body: String
    let metadata: TemplateMetadata
}

private enum TemplateFrontMatterError: Error {
    case missingClosingDelimiter
    case invalidAutoloadEntry(String)
}

private func parseFrontMatter(_ source: String) throws -> ParsedTemplateSource {
    let lines = source.split(
        omittingEmptySubsequences: false,
        whereSeparator: { character in
            character == "\r" || character == "\n"
        }
    )
    guard lines.first.map(String.init)?.trimmingCharacters(in: .whitespaces) == "---" else {
        return .init(body: source, metadata: .init())
    }

    guard let closingIndex = lines.dropFirst().firstIndex(where: {
        String($0).trimmingCharacters(in: .whitespaces) == "---"
    }) else {
        throw TemplateFrontMatterError.missingClosingDelimiter
    }

    var stylesheets: [String] = []
    var scripts: [String] = []
    var section: String?
    var subsection: String?

    for rawLine in lines[lines.index(after: lines.startIndex)..<closingIndex] {
        let line = String(rawLine)
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty || trimmed.hasPrefix("#") {
            continue
        }

        let indentation = line.prefix { $0 == " " }.count
        if indentation == 0 {
            section = trimmed == "autoload:" ? "autoload" : nil
            subsection = nil
            continue
        }

        guard section == "autoload" else { continue }

        if indentation == 2, trimmed.hasSuffix(":") {
            let name = String(trimmed.dropLast())
            guard name == "css" || name == "js" else {
                throw TemplateFrontMatterError.invalidAutoloadEntry(name)
            }
            subsection = name
            continue
        }

        guard indentation >= 4, trimmed.hasPrefix("- "), let subsection else {
            throw TemplateFrontMatterError.invalidAutoloadEntry(trimmed)
        }
        let value = String(trimmed.dropFirst(2))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard isValidAssetPath(value) else {
            throw TemplateFrontMatterError.invalidAutoloadEntry(value)
        }
        if subsection == "css" {
            stylesheets.append(value)
        } else {
            scripts.append(value)
        }
    }

    let bodyStart = lines.index(after: closingIndex)
    let body = lines[bodyStart...].map(String.init).joined(separator: "\n")
    return .init(
        body: body,
        metadata: .init(
            stylesheets: stylesheets,
            scripts: scripts
        )
    )
}

private func isValidAssetPath(_ value: String) -> Bool {
    guard !value.isEmpty, !value.contains(".."), !value.contains("\u{0}") else {
        return false
    }
    return value.hasPrefix("/")
        || value.hasPrefix("http://")
        || value.hasPrefix("https://")
        || !value.contains(":")
}
