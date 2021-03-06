<apex:component controller="RCSupportControllerHandler">
    <style>
        .oldSiteDiv {
            width: 32%;
            font-size: 18px;
            color: #f8981d;
            margin-left: 5px;
            margin-bottom: 4px;
        }
        
        .contact-support-container article.app {
            width: 255px;
        }
    </style>
    <apex:form forceSSL="{!isGuestUser}" >
   
     <c:RCSystemStatus Text="Contact Support" rendered="{!!UKPortal}"/>
     <c:RCSystemStatusUK Text="Contact Support" rendered="{!UKPortal}"/>
     <div class="oldSiteDiv">
        If you are an existing UK Fax or Pro Customer,  <a style="color:#f8981d;text-decoration:underline;" 
            href="http://help.ringcentral.co.uk">Please click here for help</a>.
     </div> 
     <div class="contact-support-container">
      <apex:commandLink action="{!openCase}">
   <article role="application" class="app">
        <div class="img-container case"></div>
        <div class="container-desc">
            <h3>Open a Case</h3>If you can't find an answer or need personalized assistance, simply open a case.</div>
    </article>
     </apex:commandLink>
    <a href='{!$Site.CurrentSiteUrl}RCCallSupport'>
    <article role="application" class="app">
        <div class="img-container call_support"></div> 
        <div class="container-desc">
            <h3>Call Support</h3>If you have a critical issue or need assistance opening a case, please call us. For other requests, please open a case online.</div>
    </article>
    </a>
    <a href='https://community.ringcentral.com/ringcentral/products/ringcentral_uk_support' target='_self'> 
<!--    <a href='{!$Site.CurrentSiteUrl}RCSupportPortalForumPage' target='_self'>  -->
    <article role="application" class="app last" style="width:255px;">
         <div class="img-container community"></div>
        <div class="container-desc">
            <h3>Ask the Community</h3>Our community of customers and product experts are ready to answer your questions.</div>
    </article>
    </a>
  </div>
    <div class="check-status">
        <!--<apex:commandLink action="{!openMyCase}">Check my case status &raquo;</apex:commandLink>-->
        <apex:outputPanel id="thePanel1" layout="block">
             <apex:commandLink action="{!openMyCase}" rendered="{!isGuestUser == true}">
                 <B>Check my case status&raquo;</B>
             </apex:commandLink>
             <c:RCSupportAdvMyCase rendered="{!!isGuestUser == true}" />
        </apex:outputPanel>
    </div>
    </apex:form>
</apex:component>
