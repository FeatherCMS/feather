public import FeatherApplication
public import MediaModule

extension Asset.File.GenerateVariant {
    public enum Error: UseCaseError {
        case assetNotFound
        case outputMissing(processorName: String)
        case commandFailed(
            processorName: String,
            command: String,
            status: Int32,
            stderr: String?
        )
    }
}
