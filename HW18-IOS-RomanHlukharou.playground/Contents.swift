import Foundation

public struct Chip {
    public enum ChipType: UInt32 {
        case small = 1
        case medium
        case big
    }
    
    public let chipType: ChipType
    
    public static func make() -> Chip {
        guard let chipType = Chip.ChipType(rawValue: UInt32(arc4random_uniform(3) + 1)) else {
            fatalError("Incorrect random value")
        }
        
        return Chip(chipType: chipType)
    }
    
    public func sodering() {
        let soderingTime = chipType.rawValue
        sleep(UInt32(soderingTime))
    }
}

class Storage {
   private var storage = [Chip]()
    var counter: Int = 0
    private let condition = NSCondition()
    var isAvailable = false
    var isEmpty: Bool {
        return storage.isEmpty
    }
    
    func push(item: Chip) {
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
    
    func pop() -> Chip {
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

class GenerateChip: Thread {
    
    private var timer = Timer()
    private var storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    override func main() {
        timer = Timer(timeInterval: 2, repeats: true) { [unowned self] _ in
            self.storage.push(item: Chip.make())
        }
        
        RunLoop.current.add(timer, forMode: .common)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 20))
    }
}

class WorkChip: Thread {
    private var storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    override func main() {
        repeat {
            let lastChip = storage.pop()
            lastChip.sodering()
            print("Чип - \(lastChip.chipType) припаян.\n")
        } while storage.isAvailable || storage.isEmpty
    }
}


let storage = Storage()
let generator = GenerateChip(storage: storage)
let worker = WorkChip(storage: storage)

generator.start()
worker.start()
