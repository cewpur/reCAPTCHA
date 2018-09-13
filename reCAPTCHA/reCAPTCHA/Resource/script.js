(function() {
    const RECAPTCHA_SITE_KEY = '%@';
    const RECAPTCHA_THEME = '%@';
    const PAGE_BG_COLOR = '%@';

    function waitReady() {
        if (document.readyState == 'complete')
            documentReady();
        else
            setTimeout(waitReady, 100);
    }

    function documentReady() {
        document.body = document.createElement('body');

        let div = document.createElement('div');

        div.style.position = 'absolute';
        div.style.top = '45%%';
        div.style.left = 'calc(50%% - 151px)';

        document.body.style.background = PAGE_BG_COLOR;
        document.body.appendChild(div);

        let meta = document.createElement('meta');

        meta.setAttribute('name', 'viewport');
        meta.setAttribute('content', 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0');

        document.head.appendChild(meta);

        showCaptcha(div);
    }

    function showCaptcha(el) {
        try {
            grecaptcha.render(el, {
                'sitekey': RECAPTCHA_SITE_KEY,
                'theme': RECAPTCHA_THEME,
                'callback': captchaSolved,
                'expired-callback': captchaExpired,
            });

            window.webkit.messageHandlers.recaptchaios.postMessage(["didLoad"]);
        } catch (_) {
            window.setTimeout(function() { showCaptcha(el) }, 50);
        }
    }

    function captchaSolved(response) {
        window.webkit.messageHandlers.recaptchaios.postMessage(["didSolve", response]);
    }

    function captchaExpired(response) {
        window.webkit.messageHandlers.recaptchaios.postMessage(["didExpire"]);
    }

    waitReady();
})();
