public import MediaModule

extension Asset.File.Add {
    public enum Error: Swift.Error, Sendable {
        case duplicatePath
    }
}
