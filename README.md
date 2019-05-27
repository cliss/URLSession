# URLSession
An exploration of URLSession and cellular restriction.

# Purpose
`URLSession` is a repo wherein I explain my expecations for how the 
[`URLSession`][urls] [`allowsCellularAccess`][aca] API should work.

It is an extremely basic iOS app that illustrates three steps:

1. Attempting a network request over Wi-Fi only.
2. Attempting to upgrade that request to be cellular-enabled.
3. Attempting to tear in-flight requests down and re-build them by hand.

Please take a look at the comments in [`ViewController`][vc] to see
my expectations versus reality.

# Pre-flighting

This is a sample app, but [the app that inspired it][v] creates a
*mountain* of requests immediately. Since there is no mechanism to
trampoline non-cellular requests to cellular-enabled requests, that
means my app is literally pre-flighting by hitting the
[Apple captive portal URL][c]. Which is not really that much better
than just using [Reachability][r].

[urls]: https://developer.apple.com/documentation/foundation/urlsession
[aca]: https://developer.apple.com/documentation/foundation/urlsessionconfiguration/1409406-allowscellularaccess
[vc]: https://github.com/cliss/URLSession/blob/master/URLSession/ViewController.swift
[v]: https://itunes.apple.com/us/app/vignette-update-contact-pics/id1455924925?mt=8
[c]: http://captive.apple.com/hotspot-detect.html
[r]: https://developer.apple.com/library/archive/samplecode/Reachability/Introduction/Intro.html
