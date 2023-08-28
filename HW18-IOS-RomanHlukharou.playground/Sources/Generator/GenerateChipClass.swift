import Foundation

public class GenerateChip: Thread {
    
    private var timer = Timer()
    private var storage: Storage
    
    public init(storage: Storage) {
        self.storage = storage
    }
    
    public override func main() {
        timer = Timer(timeInterval: 2, repeats: true) { [unowned self] _ in
            self.storage.push(item: Chip.make())
        }
        
        RunLoop.current.add(timer, forMode: .common)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 20))
    }
}
