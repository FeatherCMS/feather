public enum ObjectKeyGeneratorError: Error {
    case emptyValue
}

public protocol ObjectKeyGenerator: Sendable {
    func generate(from value: String) throws -> String
}
