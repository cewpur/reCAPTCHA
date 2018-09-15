# reCAPTCHA

<img src="https://raw.githubusercontent.com/cewpur/reCAPTCHA/master/demo/demo-light.gif" /> <img src="https://raw.githubusercontent.com/cewpur/reCAPTCHA/master/demo/demo-dark.gif" />

## About
An easy modal controller for prompting a reCAPTCHA verification. This works on a `WKWebView` which first loads the target site with your captcha gate - to harvest any cookies or sessions - before JavaScript is injected to clear the page and center a reCAPTCHA component. The following captcha JS callbacks are bridged to Swift:
* Load
* Solve
* Expiration

On successful completion, the challenge response string will be passed to the solved closure.

## Usage
The captcha screen (`UIViewController`) is presented modally as it will require considerable screen estate for the challenge. It can be instantiated like so:

```Swift
let controller = RecaptchaController(siteKey: siteKey, url: url, backgroundColor: .white,
                                     captchaTheme: .light) { (response) in
    print(response)
}

controller.didLoad = { // optional
    print("Captcha loaded")
}

controller.didExpire = { // optional
    print("Captcha expired")
}

// wrap navigation and present as normal
```

## License

MIT. I hate reCAPTCHA so if you have improvements, go ahead!
