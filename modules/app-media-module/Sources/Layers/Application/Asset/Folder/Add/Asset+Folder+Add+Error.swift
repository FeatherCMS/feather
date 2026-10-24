public import FeatherApplication
public import MediaModule

extension Asset.Folder.Add {
    public enum Error: UseCaseError {
        case invalidName, parentNotFound, duplicatePath
    }
}
