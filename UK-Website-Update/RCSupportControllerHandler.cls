public class RCSupportControllerHandler{
public String str{get;set;}
public Boolean isGuestUser{get;set;}
public String strSeesionId{get;set;}
public Boolean isTokenFound{get;set;}
public String strPageUrl{get;set;}
public  String strPostFix='';
public User objUser{get;set;}
public String strLCClassName{get;set;}
public map<String,String> mapArticleUrl{get;set;}
public map<String,String> mapArticleSummary{get;set;}
public String siteArticle {get;set;}
public List<String> articleOrderedList {get;set;}
public String CurrentURl{get;set;}
public String defaultName{get;set;}
public String ln{get;set;}
public String currentSiteURL {get;set;}
public String currentPageName{get;set;}
public String source{get;set;}


public RCSupportControllerHandler(){
   
  Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');  
  if (apexpages.currentPage().getParameters().get('ln')!=null && apexpages.currentPage().getParameters().get('ln')!= '')
    ln = apexpages.currentPage().getParameters().get('ln');
  else
    ln = '';
  System.debug('ln is ~~~~~~~~~~~~~~~~~~~'+ln);  
  if(UserInfo.getUserType()=='Guest'){
    isGuestUser=true;
  }else{
    isGuestUser=false;
  }
  // CHANGES STARTS FOR CSV BASED ARTICLE LISTING
  mapArticleUrl = new Map<String,String>();
  mapArticleSummary = new Map<String,String>();
  articleOrderedList = new List<String>();
    // CHANGES ENDS FOR CSV BASED ARTICLE LISTING
  isTokenFound=isValidTokenFound();
  objUser=new User();
  if(isGuestUser!=true){
    objUser=[SELECT AboutMe, IsActive, CommunityNickname, CompanyName, Country, CreatedDate, Department, Division, Email,  Name, IsPortalEnabled, LastLoginDate,
                UserType, Username,Profile.Name,UserRole.Name,FullPhotoUrl FROM User where id=:UserInfo.getUserId()];
  }   
  CurrentURl = Site.getBaseUrl();
        system.debug('======================='+CurrentURl);
    if(CurrentURl.contains('rcsupportCA2012')||CurrentURl.contains('success.ringcentral.ca')){
      defaultName ='Canada';
    }else {
      defaultName ='United States';
  }
  if(String.isNotBlank(ApexPages.CurrentPage().getParameters().get('LCtabId'))){
    strLCClassName=ApexPages.CurrentPage().getParameters().get('LCtabId');
  }else{
   strLCClassName='getting_0';
  }
    knowledgeArticleMap('ArticleNaviagationListForUSCAandUK', (getUKPortal() ? 'UK' :'US/CA'));
  
}

/************************ GET DOCUMENT FOR ARTICLE LISTING **********************************/

public PageReference setPageParameter(){  
  PageReference pageRef;
  String ln = apexpages.currentPage().getParameters().get('ln');
  System.debug('ln>>>>>>>>>>>>>>>>>>>>>>>>>>>'+ apexpages.currentPage().getParameters().get('ln')+'===='+ ln);
  System.debug('URL is >>>>>>>>>'+currentSiteURL);
  if(source.equalsIgnoreCase('learningCenterPage'))
     pageRef = new PageReference(currentSiteURL+'RCSupportPortalLearningCenter?LCtabId=settings_21&ln=learning_center');
  else if(source.equalsIgnoreCase('kb')) 
     pageRef = new PageReference(currentSiteURL+'RCSupportPortalLearningCenter?LCtabId=number_0&ln=kb');     
  else if(source.equalsIgnoreCase('numberTransferPage')) 
     pageRef = new PageReference(currentSiteURL+'RCSupportPortalLearningCenter?LCtabId=number_0&ln=learning_center');
  
  return pageRef;
}

  public static List<Document> getMyDocument(String docName){
        return [SELECT body, Name, bodyLength, ContentType, Url FROM Document WHERE Name = :docName];
    }
/****************************Get popular articles from query ********************************

public List<RC_Knowledge_Article__kav> getKAVList(){
    List<String> popularArticlesIDsList = new List<String>();
    List<RC_Knowledge_Article__kav> finalKavList = new List<RC_Knowledge_Article__kav>();
    try {
        List<RC_Knowledge_Article__kav> objList = new List<RC_Knowledge_Article__kav>();
        List<KnowledgeArticleViewStat> articleViewStatList = new List<KnowledgeArticleViewStat>();
        List<Id> viewStatParentIdList =  new List<Id>();
        Map<double,Id> scoreToParentMap = new Map<double,Id>();
        Map<id,RC_Knowledge_Article__kav> parentToKavMap = new Map<id,RC_Knowledge_Article__kav>(); 
        
        
        for(KnowledgeArticleViewStat viewStatbj:[SELECT Id, NormalizedScore, Parent.Id FROM KnowledgeArticleViewStat where Channel = 'portal' 
                                                    ORDER BY NormalizedScore desc limit 15]){
                System.debug('Score ============= '+ viewStatbj.NormalizedScore); 
                viewStatParentIdList.add(viewStatbj.Parent.Id) ;
                scoreToParentMap.put(viewStatbj.NormalizedScore,viewStatbj.Parent.Id);
        }                      
                               
        
        objList = [Select r.UrlName, r.Title,r.KnowledgeArticleId,r.LastPublishedDate,r.Summary From RC_Knowledge_Article__kav r  where PublishStatus='Online'
                                            AND KnowledgeArticleId IN:viewStatParentIdList AND IsVisibleInPkb = true 
                                            AND IsLatestVersion = true ];
                                            
        for (RC_Knowledge_Article__kav obj : objList){
            System.debug('obj.KnowledgeArticleId ============ '+obj.KnowledgeArticleId);
            parentToKavMap.put(obj.KnowledgeArticleId,obj);
        }  
        List<Double> aList = new List<Double>();
        aList.addAll(scoreToParentMap.keySet());
        aList.sort();
        
        List<RC_Knowledge_Article__kav> kavList = new List<RC_Knowledge_Article__kav>();
        for(Double score : aList){
            system.debug('aList ============ '+score);
            system.debug('scoreToParentMap.get(score) ============ '+scoreToParentMap.get(score));
            if(scoreToParentMap != NULL && scoreToParentMap.containsKey(score) && scoreToParentMap.get(score) != NULL){
                Id tempId = scoreToParentMap.get(score);
                system.debug('parentToKavMap.get(tempId) ============ '+parentToKavMap.get(tempId));
                if(parentToKavMap != NULL && parentToKavMap.containsKey(tempId) && parentToKavMap.get(tempId) != NULL){
                    kavList.add(parentToKavMap.get(tempId));
                    system.debug('KAVLIST ============ '+parentToKavMap.get(tempId));
                }
            }
            
        }  
        
        for(Integer i = kavList.size()-1; i>=0;i--)
        {
            finalKavList.add(kavList.get(i));
            System.debug('final ============ '+kavList.get(i).KnowledgeArticleId);
        }                            
    } catch(Exception e) {}
    return finalKavList;
}
    
    
/*********************************************************/  
 public Map<String,String> knowledgeArticleMap(String docName, String brandName){
        String[] fileLines = new String[]{};
        
        List<Document> lstDoc = getMyDocument(docName);
        try{
          if(lstDoc != null && lstDoc.size() != 0 && lstDoc[0].body != null) {              
                  String csvFile= lstDoc[0].body.toString();                 
                  fileLines = csvFile.split('#EOL#');
                  Integer counter = 0;
                  for(String line : fileLines){
                      if(!String.isBlank(line) && line != '' && line != null && ++counter > 1) {
                       
                          String[] inputvalues = line.split(',\\*-\\*,');
                          if(inputvalues != null && (inputvalues.size() == 3 || inputvalues.size() == 4)){
                          if(brandName.containsIgnoreCase('UK')){
                            if((inputvalues[0]).containsIgnoreCase('UK')){
                              if(String.isNotBlank(inputvalues[1].replaceAll('"','').trim())){
                                   mapArticleUrl.put(inputvalues[1].replaceAll('"','').trim(),inputvalues[2].trim());
                                   articleOrderedList.add(inputvalues[1].replaceAll('"','').trim());
                              }
                            }
                            else{
                              
                            }
                          } else if(brandName.containsIgnoreCase('US')){
                            if((inputvalues[0]).containsIgnoreCase('US/CA')){
                              if(String.isNotBlank(inputvalues[1].replaceAll('"','').trim())){
                                   mapArticleUrl.put(inputvalues[1].replaceAll('"','').trim(),inputvalues[2]);
                                   if(inputvalues.size() == 4)                                  
                                     mapArticleSummary.put(inputvalues[1].replaceAll('"','').trim(),(String.isBlank(inputvalues[3]) ? '' : inputvalues[3].trim()));                                    
                                   else
                                     mapArticleSummary.put(inputvalues[1].replaceAll('"','').trim(),'');
                                   
                                   articleOrderedList.add(inputvalues[1].replaceAll('"','').trim());
                              }  
                            }                            
                            else{
                            }
                          }
                          else{
                            System.debug('Brand name is Else');
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Article file not configured properly');
                            return null;                    
                          }  
                          }//value 3 or 4
                          else{                            
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Article file not configured properly');
                            return null;                            
                          }//input size not 3 or 4
                      }//if line is not blank
                  }//for all lines               
              
          } else {///when document is blank
            System.debug('ARTICLE WAS NOT CONFIGURED');
            mapArticleUrl.put('No articles configured.','No articles configured.');
            mapArticleSummary.put('No articles configured.', '');
            articleOrderedList.add('No articles configured.');
          }
        }catch(Exception e){
          System.debug('ARTICLE WAS NOT CONFIGURED End catch');
        }

       return null;
    }
 public PageReference showTabsDetail(){
   PageReference objPage=new PageReference('/RCSupportPortalLearningCenter');
   objPage.getParameters().put('LCtabId',strLCClassName);
   return objPage;
 } 
  public PageReference updateUserProfile() {
         try{
            update objUser;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Profile Successfully updated');
            ApexPages.addMessage(msg);
        }catch(Exception e ){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
            e.getMessage());
            ApexPages.addMessage(msg);
        }
     return null;
  }
public Boolean isValidTokenFound(){
   String strToken =getValidToken();
   if(strToken!=null && strToken!=''){
     return true;
   }
  return false;
}

  public String getURL() {
    return Site.getName();
  }
  
  public Boolean getUKPortal(){
    if(Site.getName()!=null && Site.getName()!='' && (Site.getName()).lastIndexOfIgnoreCase('RCSupportPortalUK')>-1){
    return true;
    }
    return false;
  }


public String strPageUrl2{get;set;}

public Pagereference validateLoginDetail(){
    try{
     if(isTokenFound==true ){       
         String tokenVal=getValidToken();   
          if(tokenVal!=null && tokenVal!=''){
            String loginToken=tokenVal;
        string username;
      string password;
      
      if(loginToken != null) {
        String[] strSplitToken = loginToken.split('&');
        username =   strSplitToken[0].split('=')[1];
        password =   strSplitToken[1].split('=')[1];
        str=username+password;
      }
      String strPage = ApexPages.CurrentPage().getParameters().get('NEXTPAGE');
      if(strPage!=null && strPage!='' && strPage.indexOf(strPostFix)>=0){
        strPage='/'+strPage.removeEndIgnoreCase(strPostFix);
      }else if(ApexPages.CurrentPage().getParameters().get('ARTICLENAME')!=null && ApexPages.CurrentPage().getParameters().get('ARTICLENAME')!=''){
         strPage='';
         strPage='/articles/RC_Knowledge_Article/'+ApexPages.CurrentPage().getParameters().get('ARTICLENAME');
      }
      Pagereference pageRef= Site.login(username,password, ''+strPage);
      pageRef.setRedirect(true);
      return pageRef;
   }
     } 
    }catch(Exception e){} 
  return null;
}

public String getNextPageName(){
       String strPage=null;
      
       if(ApexPages.currentPage().getParameters().get('startURL')!=null && ApexPages.currentPage().getParameters().get('startURL')!=''){
    strPage=ApexPages.currentPage().getParameters().get('startURL');
    if(strPage!=null && strPage!='' && strPage.indexOf('/')>=0){
      strPage=strPage.substringAfterLast('/');
      return strPage+strPostFix;
    }
    
  }
  return 'RCSupportPortalHome'+strPostFix;
}
public String getValidToken(){    
    String strToken = ApexPages.CurrentPage().getParameters().get('token');
    system.debug('=========== '+ strToken);
     if(strToken!=null && strToken!=''){
         String tokenUrlDecoded = EncodingUtil.urlDecode(strToken, 'UTF-8');
            tokenUrlDecoded = tokenUrlDecoded.replaceAll(' ', '+');
            Blob tokenDecodedBases64 = Encodingutil.base64Decode(tokenUrlDecoded);          
            Blob cryptoKey = Blob.valueOf('v7Y2g2webAqutAcr4DEC3uTAnaspEgA8');
            Blob initVector = Blob.valueof('da4atrABufastacr');
            // Decrypt the data
            Blob decryptedData = Crypto.decrypt('AES256', cryptoKey, initVector, tokenDecodedBases64);
            String tokenVal = decryptedData.toString();    
                // it is fixed for mul
           return tokenVal;
     }    
     return null;  
  
}


public Pagereference login(){
  if(isTokenFound==true){
    return validateLoginDetail();
  }else{
      PageReference objPage=new PageReference('https://service.ringcentral.com/login.asp');
      //PageReference objPage=new PageReference('http://sp2.ringcentral.com/login/login.php');
      objPage.getParameters().put('p_next_page',getNextPageName());
      objPage.setRedirect(true);
      return objPage;
   }
  return null;
}
public String strUserType{get;set;}

public Pagereference PageAuthorization(){
  if(UserInfo.getUserType()=='Guest'){
    isGuestUser=true;
  }else{
    isGuestUser=false;
    return null;
  }
  return login();
} 
public Pagereference getPageAuthorization(){
  if(UserInfo.getUserType()=='Guest'){
    isGuestUser=true;
  }else{
    isGuestUser=false;
    return null;
  }
  return login();
} 


public Pagereference openCase(){
  return new Pagereference('/RCSupportPortalCreateNewCase');
  
}
public Pagereference openMyCase(){
  return new Pagereference('/RCSupportAdvMyCases');  
}


  public String getPageDetail(){
      return ApexPages.currentPage().getUrl();
  }
  
  public Boolean getIsArticleDetailsPage(){
      String pageURL=ApexPages.currentPage().getUrl();
      if(pageURL!=null && pageURL.indexOf('TOCArticleRendererPkb')>-1){
        return true;
      }
      return false;
  }
  
  public String getURLProtocol(){
     return URL.getSalesforceBaseUrl().getProtocol();
  } 
  
  public String getCommunityId(){
       String strReturnString='false';
       for(Community objCommunity : [SELECT Id FROM Community WHERE Name = 'RingCentral Customer Community' limit 1 ]){
          strReturnString=objCommunity.id;
      }
       return strReturnString;
   }
   
   /*********************************************************************************************
  * @Description : Method to redirect control to different pages.                              *
  * @Params      : void                                                                        * 
  * @Return      : void                                                                        * 
  *********************************************************************************************/
  public PageReference redirectToPage(){
    PageReference redirectToPage = null;
    try{
      String currentURL = URL.getCurrentRequestUrl().toExternalForm();
      system.debug('#### Current URL = '+currentURL);
      if(currentURL.contains('RCSupportPortalCreateNewCase')){
        currentURL = currentURL.replace('RCSupportPortalCreateNewCase','SupportPortalCaseCreate?pageid=contact');
      }
      if(currentURL.contains('RCContactSupp')){
        currentURL = currentURL.replace('RCContactSupp','SupportPortalContact?pageid=contact');
      }
      
      system.debug('#### Replaced Current URL = '+currentURL);
      
      if(currentURL.contains('btcloudphone')){
        redirectToPage = new PageReference(currentURL);  
        redirectToPage.setRedirect(true);
        system.debug('#### Redirecting to Page = '+redirectToPage);
        return redirectToPage;
      }  
    }catch(Exception ex){
      system.debug('#### Exception at line = '+ex.getLineNumber()+' ,Exception Message = '+ex.getMessage());  
    }
    return redirectToPage;
  }
  
   
}// End of Class.
