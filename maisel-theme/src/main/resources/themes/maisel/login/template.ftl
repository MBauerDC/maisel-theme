<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayWide=false displayRequiredFields=false showAnotherWayIfPresent=true>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" class="${properties.kcHtmlClass!}">

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">
    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    
    <link rel="apple-touch-icon" sizes="180x180" href="${url.resourcesPath}/favicons/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="${url.resourcesPath}/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="${url.resourcesPath}/favicons/favicon-16x16.png">
    <link rel="mask-icon" href="${url.resourcesPath}/favicons/safari-pinned-tab.svg" color="#ff7801">
    <link rel="shortcut icon" href="${url.resourcesPath}/favicons/favicon.ico">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="msapplication-TileImage" content="${url.resourcesPath}/favicons/mstile-144x144.png">
    <meta name="msapplication-config" content="${url.resourcesPath}/favicons/browserconfig.xml">
    <meta name="theme-color" content="#ffffff">
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
</head>

<body class="${properties.kcBodyClass!}">
  <div class="${properties.kcLoginClass!}">
        <div class="${properties.kcFormCardClass!} <#if displayWide>${properties.kcFormCardAccountClass!}</#if>">
            <div class="loginLogo">
                <div class="logo">
                    <img src="${url.resourcesPath}/img/logo.svg" style="width: 100px; height: 100px;">
                </div>
            </div>
            <header class="login-pf-header">
                <#if realm.internationalizationEnabled  && locale.supported?size gt 1>
                    <div id="kc-locale">
                        <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                            <div class="kc-dropdown" id="kc-locale-dropdown">
                                <a href="#" id="kc-current-locale-link">${locale.current}</a>
                                <ul>
                                    <#list locale.supported as l>
                                        <li class="kc-dropdown-item"><a href="${l.url}">${l.label}</a></li>
                                    </#list>
                                </ul>
                            </div>
                        </div>
                    </div>
                </#if>
                <h1 id="kc-page-title"><#nested "header"></h1>
            </header>
          <div id="kc-content">
            <div id="kc-content-wrapper">

              <#-- App-initiated actions should not see warning messages about the need to complete the action -->
              <#-- during login.                                                                               -->
              <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                  <div class="alert alert-${message.type}">
                      <#if message.type = 'success'><span class="${properties.kcFeedbackSuccessIcon!}"></span></#if>
                      <#if message.type = 'warning'><span class="${properties.kcFeedbackWarningIcon!}"></span></#if>
                      <#if message.type = 'error'><span class="${properties.kcFeedbackErrorIcon!}"></span></#if>
                      <#if message.type = 'info'><span class="${properties.kcFeedbackInfoIcon!}"></span></#if>
                      <span class="kc-feedback-text">${kcSanitize(message.summary)?no_esc}</span>
                  </div>
              </#if>

              <#nested "form">

              <#if auth?has_content && auth.showTryAnotherWayLink() && showAnotherWayIfPresent>
                <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post" <#if displayWide>class="${properties.kcContentWrapperClass!}"</#if>>
                    <div <#if displayWide>class="${properties.kcFormSocialAccountContentClass!} ${properties.kcFormSocialAccountClass!}"</#if>>
                        <div class="${properties.kcFormGroupClass!}">
                            <input type="hidden" name="tryAnotherWay" value="on" />
                            <a href="#" id="try-another-way" onclick="document.forms['kc-select-try-another-way-form'].submit();return false;">${msg("doTryAnotherWay")}</a>
                        </div>
                    </div>
                </form>
              </#if>

              <#if displayInfo>
                  <div id="kc-info" class="${properties.kcSignUpClass!}">
                      <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
                          <#nested "info">
                      </div>
                  </div>
              </#if>
            </div>
          </div>

        </div>
  </div>
    <script>
        document.querySelector('#kc-locale .kc-dropdown').addEventListener('click', function(){
            if(this.classList.contains('active')){
                this.classList.remove('active');
            }else{
                this.classList.add('active');
            }
        });
    </script>
</body>
</html>
</#macro>