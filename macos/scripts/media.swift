#!/usr/bin/env swift
import Foundation

// load private MediaRemote framework (dlopen needed for ObjC class registration)
guard dlopen(
  "/System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote",
  RTLD_NOW | RTLD_GLOBAL
) != nil else {
  fputs("failed to load MediaRemote\n", stderr); exit(1)
}

let bundleURL = URL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework")
guard let bundle = CFBundleCreate(kCFAllocatorDefault, bundleURL as CFURL) else {
  fputs("failed to create bundle\n", stderr); exit(1)
}

func sym<T>(_ name: String) -> T? {
  guard let ptr = CFBundleGetFunctionPointerForName(bundle, name as CFString) else { return nil }
  return unsafeBitCast(ptr, to: T.self)
}

typealias SendCommandFn = @convention(c) (UInt32, CFDictionary?) -> Bool
typealias GetInfoFn = @convention(c) (DispatchQueue, @escaping (CFDictionary?) -> Void) -> Void
typealias RegisterFn = @convention(c) (DispatchQueue) -> Void
typealias IsPlayingFn = @convention(c) (DispatchQueue, @escaping (Bool) -> Void) -> Void

let sendCommand: SendCommandFn? = sym("MRMediaRemoteSendCommand")
let getInfo: GetInfoFn? = sym("MRMediaRemoteGetNowPlayingInfo")
let registerNotifs: RegisterFn? = sym("MRMediaRemoteRegisterForNowPlayingNotifications")
let getIsPlaying: IsPlayingFn? = sym("MRMediaRemoteGetNowPlayingApplicationIsPlaying")

// controller-based info query (macOS 15.4+ where legacy returns empty)
func queryViaController(completion: @escaping ([String: Any]?) -> Void) {
  guard
    let destCls = NSClassFromString("MRDestination"),
    let cfgCls = NSClassFromString("MRNowPlayingControllerConfiguration"),
    let ctrlCls = NSClassFromString("MRNowPlayingController")
  else { completion(nil); return }

  let dest = (destCls as AnyObject).perform(NSSelectorFromString("userSelectedDestination"))?.takeUnretainedValue()
  let cfg = (cfgCls.alloc() as AnyObject)
    .perform(NSSelectorFromString("initWithDestination:"), with: dest)?.takeUnretainedValue() as AnyObject
  cfg.setValue(false, forKey: "singleShot")
  cfg.setValue(true, forKey: "requestPlaybackState")
  cfg.setValue(true, forKey: "requestPlaybackQueue")

  let ctrl = (ctrlCls.alloc() as AnyObject)
    .perform(NSSelectorFromString("initWithConfiguration:"), with: cfg)?.takeUnretainedValue() as AnyObject
  _ = ctrl.perform(NSSelectorFromString("beginLoadingUpdates"))

  var polls = 0
  let timer = DispatchSource.makeTimerSource(queue: .main)
  timer.schedule(deadline: .now(), repeating: .milliseconds(100))
  timer.setEventHandler {
    polls += 1
    let resp = (ctrl as AnyObject).value(forKey: "response") as AnyObject?

    if let resp = resp,
       let queue = resp.value(forKey: "playbackQueue") as AnyObject?,
       let items = (queue as AnyObject).value(forKey: "contentItems") as? [AnyObject],
       !items.isEmpty {
      let loc = ((queue as AnyObject).value(forKey: "location") as? Int) ?? 0
      let item = (loc >= 0 && loc < items.count) ? items[loc] : items[0]
      var info: [String: Any] = [:]
      if let meta = item.value(forKey: "metadata") as AnyObject? {
        if let v = meta.value(forKey: "title") as? String { info["title"] = v }
        if let v = meta.value(forKey: "trackArtistName") as? String { info["artist"] = v }
        if let v = meta.value(forKey: "albumName") as? String { info["album"] = v }
      }
      timer.cancel()
      _ = ctrl.perform(NSSelectorFromString("endLoadingUpdates"))
      completion(info.isEmpty ? nil : info)
    } else if polls >= 25 {
      timer.cancel()
      _ = ctrl.perform(NSSelectorFromString("endLoadingUpdates"))
      completion(nil)
    }
  }
  timer.resume()
}

func getNowPlaying(completion: @escaping ([String: Any]) -> Void) {
  registerNotifs?(.main)

  DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
    // get playing state first
    var isPlaying = false
    let group = DispatchGroup()

    group.enter()
    if let fn = getIsPlaying {
      fn(.main) { playing in
        isPlaying = playing
        group.leave()
      }
    } else {
      group.leave()
    }

    // get track info
    group.enter()
    var trackInfo: [String: Any] = [:]
    guard let legacyGet = getInfo else {
      group.leave()
      group.notify(queue: .main) {
        queryViaController { result in
          var r = result ?? [:]
          r["isPlaying"] = isPlaying
          completion(r)
        }
      }
      return
    }
    legacyGet(.main) { cfDict in
      let dict = (cfDict as? [String: Any]) ?? [:]
      if !dict.isEmpty {
        let map: [(String, String)] = [
          ("kMRMediaRemoteNowPlayingInfoTitle", "title"),
          ("kMRMediaRemoteNowPlayingInfoArtist", "artist"),
          ("kMRMediaRemoteNowPlayingInfoAlbum", "album"),
        ]
        for (raw, key) in map {
          if let v = dict[raw] { trackInfo[key] = v }
        }
      }
      group.leave()
    }

    group.notify(queue: .main) {
      if !trackInfo.isEmpty {
        trackInfo["isPlaying"] = isPlaying
        completion(trackInfo)
      } else {
        queryViaController { result in
          var r = result ?? [:]
          r["isPlaying"] = isPlaying
          completion(r)
        }
      }
    }
  }
}

// main
let args = Array(CommandLine.arguments.dropFirst())
guard let cmd = args.first else {
  print("usage: media <get|state|toggle|next|prev>"); exit(0)
}

switch cmd {
case "toggle":
  _ = sendCommand?(2, nil)
  DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) { exit(0) }
case "next":
  _ = sendCommand?(4, nil)
  DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) { exit(0) }
case "prev":
  _ = sendCommand?(5, nil)
  DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) { exit(0) }
case "get":
  getNowPlaying { info in
    if info.isEmpty { print("nothing playing") }
    else {
      let t = info["title"] as? String ?? "?"
      let a = info["artist"] as? String ?? "?"
      print("\(t) — \(a)")
    }
    exit(0)
  }
case "state":
  getNowPlaying { info in
    if info.isEmpty { print("idle") }
    else {
      let t = info["title"] as? String ?? ""
      let a = info["artist"] as? String ?? ""
      let playing = (info["isPlaying"] as? Bool) == true ? "true" : "false"
      print("\(playing)\t\(t)\t\(a)")
    }
    exit(0)
  }
default:
  fputs("unknown: \(cmd)\n", stderr); exit(1)
}

RunLoop.main.run()
