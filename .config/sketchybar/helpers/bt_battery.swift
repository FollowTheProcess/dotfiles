import Foundation
import IOBluetooth

// Dumps every connected Bluetooth device's battery as JSON, one shot.
//
// system_profiler exposes Apple-vendor batteries directly but is slow (~120ms),
// so both airpods.sh and headphones.sh used to fork it and parse jq twice per
// bluetooth_change. This helper enumerates paired-and-connected devices via
// IOBluetooth (same path the macOS Bluetooth menu uses) and emits all four
// private battery selectors per device. The caller picks the field it needs.
//
// The selectors aren't KVC-compliant so we resolve them through the ObjC
// runtime. A missing/unsupported selector returns 0, which the caller treats
// as "not reporting" (e.g. AirPod in case, dead headphones).

typealias BatteryFn = @convention(c) (AnyObject, Selector) -> Int

func batteryLevel(_ device: IOBluetoothDevice, selector name: String) -> Int {
  let sel = NSSelectorFromString(name)
  guard let method = class_getInstanceMethod(IOBluetoothDevice.self, sel) else {
    return 0
  }
  let fn = unsafeBitCast(method_getImplementation(method), to: BatteryFn.self)
  return fn(device as AnyObject, sel)
}

let paired = IOBluetoothDevice.pairedDevices() ?? []

var devices: [[String: Any]] = []
for case let device as IOBluetoothDevice in paired where device.isConnected() {
  devices.append([
    "name": device.name ?? "",
    "address": device.addressString ?? "",
    "left": batteryLevel(device, selector: "batteryPercentLeft"),
    "right": batteryLevel(device, selector: "batteryPercentRight"),
    "case": batteryLevel(device, selector: "batteryPercentCase"),
    "single": batteryLevel(device, selector: "batteryPercentSingle"),
  ])
}

let data = try JSONSerialization.data(withJSONObject: devices, options: [])
FileHandle.standardOutput.write(data)
FileHandle.standardOutput.write(Data("\n".utf8))
