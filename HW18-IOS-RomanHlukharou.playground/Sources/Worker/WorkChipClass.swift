import Foundation

public class WorkChip: Thread {
    private var storage: Storage
    
    public init(storage: Storage) {
        self.storage = storage
    }
    
    public override func main() {
        repeat {
            let lastChip = storage.pop()
            lastChip.sodering()
            print("Чип - \(lastChip.chipType) припаян.\n")
        } while storage.isAvailable || storage.isEmpty
    }
}
