import FeatherDomain

struct TestObjectKeyGenerator: ObjectKeyGenerator {
    func generate(from value: String) throws -> String {
        value
    }
}
