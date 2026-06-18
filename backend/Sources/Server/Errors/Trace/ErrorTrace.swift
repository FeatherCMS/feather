//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 19..
//

public struct ErrorTrace: Encodable {
    public let type: Any
    public let logMessage: String
    public let children: [ErrorTrace]

    public init(
        type: Any,
        logMessage: String,
        children: [ErrorTrace]
    ) {
        self.type = type
        self.logMessage = logMessage
        self.children = children
    }

    private enum CodingKeys: String, CodingKey {
        case type = "id"
        case logMessage = "message"
        case children = "reasons"
    }

    public func encode(
        to encoder: any Encoder
    ) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(stringValue(for: type), forKey: .type)
        try container.encode(logMessage, forKey: .logMessage)
        if !children.isEmpty {
            try container.encode(children, forKey: .children)
        }
    }

    public var plainTextValue: String {
        format(currentStack: self)
    }

    // MARK: -

    private func stringValue(
        for type: Any
    ) -> String {
        String(reflecting: type)
    }

    private func format(
        currentStack: ErrorTrace,
        prefix: String = "",
        isLast: Bool = true
    ) -> String {
        let type = stringValue(for: currentStack.type)
        let message = currentStack.logMessage

        let branch = prefix.isEmpty ? "" : (isLast ? "└─ " : "├─ ")
        var output = "\(prefix)\(branch)\(type): \"\(message)\"\n"
        let childPrefix = prefix + (isLast ? "    " : "│   ")

        let childCount = currentStack.children.count
        for (index, child) in currentStack.children.enumerated() {
            let isLastChild = index == childCount - 1
            output += format(
                currentStack: child,
                prefix: childPrefix,
                isLast: isLastChild
            )
        }
        return output
    }
}
