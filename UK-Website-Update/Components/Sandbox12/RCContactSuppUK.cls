<apex:component controller="RCSupportControllerHandler">
    <style>
        .caseStatus-button{
            margin-left: -21px;
            width: 220px;
        }
        .oldSiteDiv {
            width: 32%;
            font-size: 18px;
            color: #66a2e8;
            margin-left: 5px;
            margin-bottom: 4px;
        } 
        .contact-support-container .container-desc h3{
            color: #709fca ! important;
        }
        .contact-support-container .img-container.case {
            background: url('{!URLFOR($Resource.RCSupportPortal, 'supportPortal/img/icon_1.png')}') 57px 25px no-repeat;
            display: block;
            width: 200px;
        }
 
        .contact-support-container .img-container.call_support {
            background: url('{!URLFOR($Resource.RCSupportPortal, 'supportPortal/img/icon_3.png')}') 64px 25px no-repeat;
            display: block;
            width: 200px;
        }

        .contact-support-container .img-container.community {
            background: url('{!URLFOR($Resource.RCSupportPortal, 'supportPortal/img/icon_4.png')}') 70px 25px no-repeat;
            display: block;
            width: 200px;
        }
        
        .contact-support-container article.app {
        	width: 255px;
        }
        
    </style>
    <apex:form forceSSL="{!isGuestUser}" >
   
     <c:RCSystemStatus Text="Contact Support"/>
     <div class="contact-support-container" style="width: 965px;">
    <a href='https://community.ringcentral.com/ringcentral/products/ringcentral_uk_support' target='_self'> 
<!--    <a href='{!$Site.CurrentSiteUrl}RCSupportPortalForumPage' target='_self'>  -->
    <article role="application" class="app" style="width:255px;">
         <div class="img-container community"></div>
        <div class="container-desc">
            <h3>Ask the Community</h3>Our community of customers and product experts are ready to answer your questions.</div>
    </article>
    </a>
      <apex:commandLink action="{!openCase}">
   <article role="application" class="app">
        <div class="img-container case"></div>
        <div class="container-desc">
            <h3>Open a Case</h3>If you can't find an answer or need personalized assistance, simply open a case.</div>
    </article>
     </apex:commandLink>
    <a href='{!$Site.CurrentSiteUrl}RCCallSupport'>
    <article role="application" class="app last">
        <div class="img-container call_support"></div> 
        <div class="container-desc">
            <h3>Call Support</h3>If you have a critical issue or need assistance opening a case, please call us. For other requests, please open a case online.</div>
    </article>
    </a>
  </div>
    <div class="check-status">
        <!--<apex:commandLink action="{!openMyCase}">Check my case status &raquo;</apex:commandLink>-->
        <apex:outputPanel id="thePanel1" layout="block">
            <!--  <apex:commandLink action="{!openMyCase}" rendered="{!isGuestUser == true}">
                 <B>Check my case status&raquo;</B>
             </apex:commandLink> -->
             <apex:commandLink action="{!openMyCase}"  rendered="{!isGuestUser == true}" type="image/png"><apex:image value="{!URLFOR($Resource.RCSupportPortal, 'supportPortal/img/CT-4070_button.png')}" styleClass="caseStatus-button"/></apex:commandLink>
             <c:RCSupportAdvMyCase rendered="{!!isGuestUser == true}" />
        </apex:outputPanel>
    </div>
    </apex:form>
    
    <style>
        .status {
            width: 960px;
         }
    </style>    
</apex:component>
