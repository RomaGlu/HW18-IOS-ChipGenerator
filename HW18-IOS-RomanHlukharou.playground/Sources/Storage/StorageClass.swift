import Foundation

public class Storage {
    
    public var storage = [Chip]()
    public var counter: Int
    public let condition = NSCondition()
    public var isAvailable = false
    
    public init(counter: Int) {
        self.counter = counter
        
    }
    
    public var isEmpty: Bool {
        return storage.isEmpty
    }
    
   public func push(item: Chip) {
        condition.lock()
        storage.append(item)
        counter += 1
        print("Чип номер \(counter) добавлен в хранилище.")
        print("Чипы в наличии:")
        storage.forEach({ print("Чип \($0.chipType) размера.\n")})
        isAvailable = true
        condition.signal()
        condition.unlock()
    }
    
   public func pop() -> Chip {
        while !isAvailable {
            condition.wait()
        }
        let lastChip = storage.removeLast()
        condition.signal()
        condition.unlock()
        if isEmpty {
            isAvailable = false
        }
        return lastChip
    }
}
