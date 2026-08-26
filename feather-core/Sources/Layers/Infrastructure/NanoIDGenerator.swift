import FeatherDomain
import NanoID

public struct NanoIDGenerator: IDGenerator {
    public init() {}

    public func generate() -> String {
        NanoID().rawValue
    }
}
