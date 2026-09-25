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
    case invalidEntry(String)
    case invalidAssetEntry(String)
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

    let frontMatterLines = lines[lines.index(after: lines.startIndex)..<closingIndex]
        .compactMap(FrontMatterLine.init)
    var parser = FrontMatterParser(lines: frontMatterLines)
    let values = try parser.parse()
    try validateAssetValues(values)

    let bodyStart = lines.index(after: closingIndex)
    let body = lines[bodyStart...].map(String.init).joined(separator: "\n")
    return .init(
        body: body,
        metadata: .init(
            context: values.mapValues(\.sendableValue)
        )
    )
}

private struct FrontMatterLine {

    let indentation: Int
    let content: String

    init?(rawValue: Substring) {
        let line = String(rawValue)
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !trimmed.hasPrefix("#") else {
            return nil
        }
        let indentation = line.prefix { $0 == " " }.count
        guard !line.prefix(indentation).contains("\t") else {
            return nil
        }
        self.indentation = indentation
        self.content = String(line.dropFirst(indentation))
    }
}

private indirect enum FrontMatterValue: Sendable {

    case string(String)
    case boolean(Bool)
    case integer(Int)
    case decimal(Double)
    case array([FrontMatterValue])
    case object([String: FrontMatterValue])
    case null

    var sendableValue: any Sendable {
        switch self {
        case .string(let value): value
        case .boolean(let value): value
        case .integer(let value): value
        case .decimal(let value): value
        case .array(let values): values.map(\.sendableValue)
        case .object(let values): values.mapValues(\.sendableValue)
        case .null: ""
        }
    }
}

private struct FrontMatterParser {

    let lines: [FrontMatterLine]
    var index = 0

    mutating func parse() throws -> [String: FrontMatterValue] {
        guard let firstLine = lines.first else { return [:] }
        let value = try parseBlock(indentation: firstLine.indentation)
        guard case .object(let values) = value else {
            throw TemplateFrontMatterError.invalidEntry("Front matter must be a mapping")
        }
        guard index == lines.endIndex else {
            throw TemplateFrontMatterError.invalidEntry(lines[index].content)
        }
        return values
    }

    private mutating func parseBlock(
        indentation: Int
    ) throws -> FrontMatterValue {
        guard index < lines.endIndex else { return .object([:]) }
        guard lines[index].indentation == indentation else {
            throw TemplateFrontMatterError.invalidEntry(lines[index].content)
        }
        if lines[index].content == "-"
            || lines[index].content.hasPrefix("- ") {
            return try parseSequence(indentation: indentation)
        }
        return try parseMapping(indentation: indentation)
    }

    private mutating func parseMapping(
        indentation: Int
    ) throws -> FrontMatterValue {
        var values: [String: FrontMatterValue] = [:]
        while index < lines.endIndex {
            let line = lines[index]
            guard line.indentation == indentation else { break }
            guard !line.content.hasPrefix("- "), line.content != "-" else {
                break
            }
            guard let (key, rawValue) = splitMapping(line.content) else {
                throw TemplateFrontMatterError.invalidEntry(line.content)
            }
            index += 1
            values[key] = try parseValue(
                rawValue,
                parentIndentation: indentation
            )
        }
        return .object(values)
    }

    private mutating func parseSequence(
        indentation: Int
    ) throws -> FrontMatterValue {
        var values: [FrontMatterValue] = []
        while index < lines.endIndex {
            let line = lines[index]
            guard line.indentation == indentation else { break }
            guard line.content == "-" || line.content.hasPrefix("- ") else {
                break
            }
            let item = line.content == "-"
                ? ""
                : String(line.content.dropFirst(2))
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            index += 1

            if item.isEmpty {
                values.append(try parseNestedValue(
                    parentIndentation: indentation
                ))
                continue
            }

            if let (key, rawValue) = splitMapping(item) {
                var object: [String: FrontMatterValue] = [:]
                object[key] = try parseValue(
                    rawValue,
                    parentIndentation: indentation
                )
                if index < lines.endIndex,
                    lines[index].indentation > indentation
                {
                    let continuationIndentation = lines[index].indentation
                    let continuation = try parseBlock(
                        indentation: continuationIndentation
                    )
                    guard case .object(let continuationObject) = continuation
                    else {
                        throw TemplateFrontMatterError.invalidEntry(
                            lines[index - 1].content
                        )
                    }
                    object.merge(continuationObject) { _, new in new }
                }
                values.append(.object(object))
            }
            else {
                values.append(parseScalar(item))
            }
        }
        return .array(values)
    }

    private mutating func parseValue(
        _ rawValue: String,
        parentIndentation: Int
    ) throws -> FrontMatterValue {
        if rawValue == "|" || rawValue == ">" {
            return try parseMultilineValue(
                parentIndentation: parentIndentation,
                folded: rawValue == ">"
            )
        }
        if !rawValue.isEmpty {
            return parseScalar(rawValue)
        }
        return try parseNestedValue(parentIndentation: parentIndentation)
    }

    private mutating func parseNestedValue(
        parentIndentation: Int
    ) throws -> FrontMatterValue {
        guard index < lines.endIndex,
            lines[index].indentation > parentIndentation
        else {
            return .string("")
        }
        return try parseBlock(indentation: lines[index].indentation)
    }

    private mutating func parseMultilineValue(
        parentIndentation: Int,
        folded: Bool
    ) throws -> FrontMatterValue {
        var values: [String] = []
        while index < lines.endIndex,
            lines[index].indentation > parentIndentation
        {
            let line = lines[index]
            values.append(String(line.content))
            index += 1
        }
        return .string(values.joined(separator: folded ? " " : "\n"))
    }
}

private func splitMapping(_ value: String) -> (String, String)? {
    var quote: Character?
    for index in value.indices {
        let character = value[index]
        if character == "'" || character == "\"" {
            if quote == character {
                quote = nil
            }
            else if quote == nil {
                quote = character
            }
        }
        guard character == ":", quote == nil else { continue }
        let nextIndex = value.index(after: index)
        guard nextIndex == value.endIndex
            || value[nextIndex].isWhitespace
        else {
            continue
        }
        let key = unquote(String(value[..<index]).trimmingCharacters(in: .whitespaces))
        let rawValue = String(value[nextIndex...])
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty else { return nil }
        return (key, rawValue)
    }
    return nil
}

private func parseScalar(_ value: String) -> FrontMatterValue {
    let value = value.trimmingCharacters(in: .whitespacesAndNewlines)
    if value.hasPrefix("[") && value.hasSuffix("]") {
        let contents = String(value.dropFirst().dropLast())
        return .array(
            splitInlineValues(contents).map(parseScalar)
        )
    }
    if value.hasPrefix("{") && value.hasSuffix("}") {
        let contents = String(value.dropFirst().dropLast())
        let object = splitInlineValues(contents).reduce(
            into: [String: FrontMatterValue]()
        ) { result, entry in
            guard let (key, rawValue) = splitMapping(entry) else { return }
            result[unquote(key)] = parseScalar(rawValue)
        }
        return .object(object)
    }
    if value == "true" { return .boolean(true) }
    if value == "false" { return .boolean(false) }
    if value == "null" || value == "~" { return .null }
    if let integer = Int(value) { return .integer(integer) }
    if let decimal = Double(value) { return .decimal(decimal) }
    return .string(unquote(value))
}

private func splitInlineValues(_ value: String) -> [String] {
    var result: [String] = []
    var start = value.startIndex
    var quote: Character?
    for index in value.indices {
        let character = value[index]
        if character == "'" || character == "\"" {
            if quote == character { quote = nil }
            else if quote == nil { quote = character }
        }
        guard character == ",", quote == nil else { continue }
        result.append(
            String(value[start..<index]).trimmingCharacters(in: .whitespaces)
        )
        start = value.index(after: index)
    }
    let last = String(value[start...]).trimmingCharacters(in: .whitespaces)
    if !last.isEmpty { result.append(last) }
    return result
}

private func unquote(_ value: String) -> String {
    guard value.count >= 2,
        let first = value.first,
        let last = value.last,
        (first == "'" || first == "\""),
        first == last
    else { return value }
    let unquoted = String(value.dropFirst().dropLast())
    if first == "\"" {
        return unquoted
            .replacingOccurrences(of: "\\\"", with: "\"")
            .replacingOccurrences(of: "\\\\", with: "\\")
    }
    return unquoted.replacingOccurrences(of: "''", with: "'")
}

private func validateAssetValues(
    _ values: [String: FrontMatterValue]
) throws {
    for key in ["css", "js"] {
        guard let value = values[key] else { continue }
        guard case .array(let entries) = value else {
            throw TemplateFrontMatterError.invalidAssetEntry(key)
        }
        for entry in entries {
            guard case .string(let path) = entry,
                isValidAssetPath(path)
            else {
                throw TemplateFrontMatterError.invalidAssetEntry(key)
            }
        }
    }
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
