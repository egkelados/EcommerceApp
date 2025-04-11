import Foundation
import os.log

protocol LoggerProtocol {
  func log(_ message: String)
  func debug(_ message: String)
  func error(_ message: String)
  func info(_ message: String)
}

class Logger: LoggerProtocol {
  private let logger: OSLog
  
  init(subsystem: Bundle = .main , category: String? = nil) {
    logger = OSLog(subsystem: subsystem.bundleIdentifier ?? "default", category: category ?? "category")
  }
  
  func log(_ message: String) {
    os_log("%{public}@", log: logger, type: .default, message)
  }
  
  func debug(_ message: String) {
    os_log("%{public}@", log: logger, type: .debug, message)
  }
  
  func error(_ message: String) {
    os_log("%{public}@", log: logger, type: .error, message)
  }
  
  func info(_ message: String) {
    os_log("%{public}@", log: logger, type: .info, message)
  }
}
