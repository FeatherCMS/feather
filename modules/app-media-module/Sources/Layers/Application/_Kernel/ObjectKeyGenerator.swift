public enum ObjectKeyGeneratorError: Swift.Error, Equatable {
    case emptyValue
}

public protocol ObjectKeyGenerator: Sendable {
    func generate(from value: String) throws -> String
}

