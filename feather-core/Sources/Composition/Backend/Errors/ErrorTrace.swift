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
        try container.encode(String(reflecting: type), forKey: .type)
        try container.encode(logMessage, forKey: .logMessage)
        if !children.isEmpty {
            try container.encode(children, forKey: .children)
        }
    }

    public var plainTextValue: String {
        format(currentStack: self)
    }

    private func format(
        currentStack: ErrorTrace,
        prefix: String = "",
        isLast: Bool = true
    ) -> String {
        let type = String(reflecting: currentStack.type)
        let branch = prefix.isEmpty ? "" : (isLast ? "└─ " : "├─ ")
        var output =
            "\(prefix)\(branch)\(type): \"\(currentStack.logMessage)\"\n"
        let childPrefix = prefix + (isLast ? "    " : "│   ")

        for (index, child) in currentStack.children.enumerated() {
            output += format(
                currentStack: child,
                prefix: childPrefix,
                isLast: index == currentStack.children.count - 1
            )
        }
        return output
    }
}
