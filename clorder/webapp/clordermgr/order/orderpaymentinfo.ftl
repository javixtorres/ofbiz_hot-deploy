<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<#macro maskSensitiveNumber cardNumber>
  <#assign cardNumberDisplay = "">
  <#if cardNumber?has_content>
    <#assign size = cardNumber?length - 4>
    <#if (size > 0)>
      <#list 0 .. size-1 as foo>
        <#assign cardNumberDisplay = cardNumberDisplay + "*">
      </#list>
      <#assign cardNumberDisplay = cardNumberDisplay + cardNumber[size .. size + 3]>
    <#else>
      <#-- but if the card number has less than four digits (ie, it was entered incorrectly), display it in full -->
      <#assign cardNumberDisplay = cardNumber>
    </#if>
  </#if>
  ${cardNumberDisplay?if_exists}
</#macro>

<div class="screenlet">
  <div class="screenlet-title-bar">
      <ul><li class="h3">&nbsp;${uiLabelMap.AccountingPaymentInformation}</li></ul>
      <br class="clear"/>
  </div>
  <div class="screenlet-body">
     <table class="basic-table" cellspacing='0'>
     <#assign orderTypeId = orderReadHelper.getOrderTypeId()>
     <#if orderTypeId == "PURCHASE_ORDER">
       <tr>
         <th>${uiLabelMap.AccountingPaymentID}</th>
         <th>${uiLabelMap.CommonTo}</th>
         <th>${uiLabelMap.CommonAmount}</th>
         <th>${uiLabelMap.CommonStatus}</th>
       </tr>
       <#list orderPaymentPreferences as orderPaymentPreference>
         <#assign payments = orderPaymentPreference.getRelated("Payment", null, null, false)>
         <#list payments as payment>
           <#assign statusItem = payment.getRelatedOne("StatusItem", false)>
           <#assign partyName = delegator.findOne("PartyNameView", {"partyId" : payment.partyIdTo}, true)>
           <tr>
             <#if security.hasEntityPermission("PAY_INFO", "_VIEW", session) || security.hasEntityPermission("ACCOUNTING", "_VIEW", session)>
               <td><a href="/claccounting/control/paymentOverview?paymentId=${payment.paymentId}">${payment.paymentId}</a></td>
             <#else>
               <td>${payment.paymentId}</td>
             </#if>
             <td>${partyName.groupName?if_exists}${partyName.lastName?if_exists} ${partyName.firstName?if_exists} ${partyName.middleName?if_exists}
             <#if security.hasPermission("PARTYMGR_VIEW", session) || security.hasPermission("PARTYMGR_ADMIN", session)>
               [<a href="/clpartymgr/control/viewprofile?partyId=${partyId}">${partyId}</a>]
             <#else>
               [${partyId}]
             </#if>
             </td>
             <td><@ofbizCurrency amount=payment.amount?if_exists/></td>
             <td>${statusItem.description}</td>
           </tr>
         </#list>
       </#list>
       <#-- invoices -->
       <#if invoices?has_content>
         <tr><td colspan="4"><hr /></td></tr>
         <tr>
           <td align="right" valign="top" width="29%">&nbsp;<span class="label">${uiLabelMap.OrderInvoices}</span></td>
           <td width="1%">&nbsp;</td>
           <td valign="top" width="60%">
             <#list invoices as invoice>
               <div>${uiLabelMap.CommonNbr}<a href="/claccounting/control/invoiceOverview?invoiceId=${invoice}${externalKeyParam}" class="buttontext">${invoice} ${invoice.statusId}</a>
               (<a target="_BLANK" href="/claccounting/control/invoice.pdf?invoiceId=${invoice}${externalKeyParam}" class="buttontext">PDF</a>)</div>
               <!--
                   <li>
                    <form name="receivePurchaseOrderForm" action="/facility/control/quickShipPurchaseOrder?externalLoginKey=${externalLoginKey}" method="post">
                      <input type="hidden" name="initialSelected" value="Y"/>
                      <input type="hidden" name="orderId" value="${orderId}"/>
                      <input type="hidden" name="purchaseOrderId" value="${orderId}"/>
                      <input type="hidden" name="partialReceive" value="Y"/>
                      <select name="facilityId">
                        <#list ownedFacilities as facility>
                          <option value="${facility.facilityId}">${facility.facilityName}</option>
                        </#list>
                      </select>
                      </form>
                      <a href="javascript:document.receivePurchaseOrderForm.submit()" class="buttontext">${uiLabelMap.CommonReceive}</a>
                  </li>
                  -->
             </#list>
           </td>
           <td width="10%">&nbsp;</td>
         </tr>
         <#else>
         <#--CODIGOLINUX crear factura -->
         
         <tr><td colspan="4"><hr /></td></tr>
         <#--
         <tr>
           <td align="right" valign="top" width="29%">&nbsp;<span class="label">${uiLabelMap.OrderInvoices}</span></td>
           <td width="1%">&nbsp;</td>
           <td valign="top" width="60%">
              <div><a href="/claccounting/control/autoInvoiceCreate?orderId=${orderId}" class="buttontext">Crear Factura</a> </div>
           </td>
           <td width="10%">&nbsp;</td>
         </tr>
         -->
         <tr>
          <td align="right" valign="top" width="29%">&nbsp;<span class="label">${uiLabelMap.OrderInvoices}</span></td>
           <td width="1%">&nbsp;</td>
           <td valign="top" width="60%">
           
           
                    <form name="crearFacturaForm" action="/claccounting/control/autoInvoiceCreate?externalLoginKey=${externalLoginKey}" method="post">
                      <input type="hidden" name="orderId" value="${orderId}"/>
                    <!--
                      <input type="hidden" name="initialSelected" value="Y"/>
                      <input type="hidden" name="orderId" value="${orderId}"/>
                      <input type="hidden" name="purchaseOrderId" value="${orderId}"/>
                      <input type="hidden" name="partialReceive" value="Y"/>
                      <select name="facilityId">
                        <#list ownedFacilities as facility>
                          <option value="${facility.facilityId}">${facility.facilityName}</option>
                        </#list>
                      </select>
                      -->
                      </form>
                      <a href="javascript:document.crearFacturaForm.submit()" class="buttontext">Crear Factura</a>
                      
            </td>
           <td width="10%">&nbsp;</td>
          </tr>
       </#if>       
     <#else>

     <#-- order payment status -->
     <tr>
       <td align="center" valign="top" width="29%" class="label">&nbsp;${uiLabelMap.OrderStatusHistory}</td>
       <td width="1%">&nbsp;</td>
       <td width="60%">
         <#assign orderPaymentStatuses = orderReadHelper.getOrderPaymentStatuses()>
         <#if orderPaymentStatuses?has_content>
           <#list orderPaymentStatuses as orderPaymentStatus>
             <#assign statusItem = orderPaymentStatus.getRelatedOne("StatusItem", false)?if_exists>
             <#if statusItem?has_content>
                <div>
                  ${statusItem.get("description",locale)} <#if orderPaymentStatus.statusDatetime?has_content>- ${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(orderPaymentStatus.statusDatetime, "", locale, timeZone)!}</#if>
                  &nbsp;
                  ${uiLabelMap.CommonBy} - [${orderPaymentStatus.statusUserLogin?if_exists}]
                </div>
             </#if>
           </#list>
         </#if>
       </td>
       <td width="10%">&nbsp;</td>
     </tr>
     <tr><td colspan="4"><hr /></td></tr>
     <#if orderPaymentPreferences?has_content || billingAccount?has_content || invoices?has_content>
        <#list orderPaymentPreferences?sort_by("createdStamp") as orderPaymentPreference>
          <#assign paymentList = orderPaymentPreference.getRelated("Payment", null, null, false)>
          <#assign pmBillingAddress = {}>
          <#assign oppStatusItem = orderPaymentPreference.getRelatedOne("StatusItem", false)>
          <#if outputted?default("false") == "true">
            <tr><td colspan="4"><hr /></td></tr>
          </#if>
          <#assign outputted = "true">
          <#-- try the paymentMethod first; if paymentMethodId is specified it overrides paymentMethodTypeId -->
          <#assign paymentMethod = orderPaymentPreference.getRelatedOne("PaymentMethod", false)?if_exists>
          <!--
          Prubas para ver que tome PRETTY_CASH
          ${paymentMethod.paymentMethodId?if_exists}
          paymentMethod.paymentMethodId == "PRETTY_CASH"
          -->
          <#if !paymentMethod?has_content || paymentMethod?has_content > <!-- Se ingresa siempre a este if, quitar en algun momento -->
          
            <#assign paymentMethodType = orderPaymentPreference.getRelatedOne("PaymentMethodType", false)>
            <#if paymentMethodType.paymentMethodTypeId == "EXT_BILLACT">
                <#assign outputted = "false">
                <#-- billing account -->
                <#if billingAccount?exists>
                  <#if outputted?default("false") == "true">
                    <tr><td colspan="4"><hr /></td></tr>
                  </#if>
                  <tr>
                    <td align="right" valign="top" width="29%">
                      <#-- billing accounts require a special OrderPaymentPreference because it is skipped from above section of OPPs -->
                      <div>&nbsp;<span class="label">${uiLabelMap.AccountingBillingAccount}
                      </span>&nbsp;<br />
                      <span class="label">
                      (Linea de Credito)</span>&nbsp;
                          <#if billingAccountMaxAmount?has_content>
                          <br />${uiLabelMap.OrderPaymentMaximumAmount}: <@ofbizCurrency amount=billingAccountMaxAmount?default(0.00) isoCode=currencyUomId/>
                          </#if>
                          </div>
                    </td>
                    <td width="1%">&nbsp;</td>
                    <td valign="top" width="60%">
                        <table class="basic-table" cellspacing='0'>
                            <tr>
                                <td valign="top">
                                    ${uiLabelMap.CommonNbr}<a href="/claccounting/control/EditBillingAccount?billingAccountId=${billingAccount.billingAccountId}${externalKeyParam}" class="buttontext">${billingAccount.billingAccountId}</a>  - ${billingAccount.description?if_exists}
                                </td>
                                <!-- 
                                Se anula el boton RECIBIR PAGO
                                <td valign="top" align="right">
                                    <#if orderPaymentPreference.statusId != "PAYMENT_SETTLED" && orderPaymentPreference.statusId != "PAYMENT_RECEIVED">
                                        <a href="<@ofbizUrl>receivepayment?${paramString}</@ofbizUrl>" class="buttontext">${uiLabelMap.AccountingReceivePayment}</a>
                                    </#if>
                                </td>
                                -->
                            </tr>
                        </table>
                    </td>
                    <td width="10%">
                        <#if (!orderHeader.statusId.equals("ORDER_COMPLETED")) && !(orderHeader.statusId.equals("ORDER_REJECTED")) && !(orderHeader.statusId.equals("ORDER_CANCELLED"))>
                            <#if orderPaymentPreference.statusId != "PAYMENT_SETTLED">
                              <div>
                                <a href="javascript:document.CancelOrderPaymentPreference_${orderPaymentPreference.orderPaymentPreferenceId}.submit()" class="buttontext">${uiLabelMap.CommonCancel}</a>
                                <form name="CancelOrderPaymentPreference_${orderPaymentPreference.orderPaymentPreferenceId}" method="post" action="<@ofbizUrl>updateOrderPaymentPreference</@ofbizUrl>">
                                  <input type="hidden" name="orderId" value="${orderId}" />
                                  <input type="hidden" name="orderPaymentPreferenceId" value="${orderPaymentPreference.orderPaymentPreferenceId}" />
                                  <input type="hidden" name="statusId" value="PAYMENT_CANCELLED" />
                                  <input type="hidden" name="checkOutPaymentId" value="${paymentMethod.paymentMethodTypeId?if_exists}" />
                                </form>
                              </div>
                            </#if>
                        </#if>
                    </td>
                  </tr>
                </#if>
            <#elseif paymentMethodType.paymentMethodTypeId == "FIN_ACCOUNT">
              <#assign finAccount = orderPaymentPreference.getRelatedOne("FinAccount", false)?if_exists/>
              <#if (finAccount?has_content)>
                <#assign gatewayResponses = orderPaymentPreference.getRelated("PaymentGatewayResponse", null, null, false)>
                <#assign finAccountType = finAccount.getRelatedOne("FinAccountType", false)?if_exists/>
                <tr>
                  <td align="right" valign="top" width="29%">
                    <div>
                    <span class="label">&nbsp;${uiLabelMap.AccountingFinAccount}</span>
                    <#if orderPaymentPreference.maxAmount?has_content>
                       <br />${uiLabelMap.OrderPaymentMaximumAmount}: <@ofbizCurrency amount=orderPaymentPreference.maxAmount?default(0.00) isoCode=currencyUomId/>
                    </#if>
                    </div>
                  </td>
                  <td width="1%">&nbsp;</td>
                  <td valign="top" width="60%">
                    <div>
                      <#if (finAccountType?has_content)>
                        ${finAccountType.description?default(finAccountType.finAccountTypeId)}&nbsp;
                      </#if>
                      #${finAccount.finAccountCode?default(finAccount.finAccountId)} (<a href="/claccounting/control/EditFinAccount?finAccountId=${finAccount.finAccountId}${externalKeyParam}" class="buttontext">${finAccount.finAccountId}</a>)
                      <br />
                      ${finAccount.finAccountName?if_exists}
                      <br />

                      <#-- Authorize and Capture transactions -->
                      <div>
                        <#if orderPaymentPreference.statusId != "PAYMENT_SETTLED">
                          <a href="/claccounting/control/AuthorizeTransaction?orderId=${orderId?if_exists}&amp;orderPaymentPreferenceId=${orderPaymentPreference.orderPaymentPreferenceId}${externalKeyParam}" class="buttontext">${uiLabelMap.AccountingAuthorize}</a>
                        </#if>
                        <#if orderPaymentPreference.statusId == "PAYMENT_AUTHORIZED">
                          <a href="/claccounting/control/CaptureTransaction?orderId=${orderId?if_exists}&amp;orderPaymentPreferenceId=${orderPaymentPreference.orderPaymentPreferenceId}${externalKeyParam}" class="buttontext">${uiLabelMap.AccountingCapture}</a>
                        </#if>
                      </div>
                    </div>
                    <#if gatewayResponses?has_content>
                      <div>
                        <hr />
                        <#list gatewayResponses as gatewayResponse>
                          <#assign transactionCode = gatewayResponse.getRelatedOne("TranCodeEnumeration", false)>
                          ${(transactionCode.get("description",locale))?default("Unknown")}:
                          <#if gatewayResponse.transactionDate?has_content>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(gatewayResponse.transactionDate, "", locale, timeZone)!} </#if>
                          <@ofbizCurrency amount=gatewayResponse.amount isoCode=currencyUomId/><br />
                          (<span class="label">${uiLabelMap.OrderReference}</span>&nbsp;${gatewayResponse.referenceNum?if_exists}
                          <span class="label">${uiLabelMap.OrderAvs}</span>&nbsp;${gatewayResponse.gatewayAvsResult?default("N/A")}
                          <span class="label">${uiLabelMap.OrderScore}</span>&nbsp;${gatewayResponse.gatewayScoreResult?default("N/A")})
                          <a href="/claccounting/control/ViewGatewayResponse?paymentGatewayResponseId=${gatewayResponse.paymentGatewayResponseId}${externalKeyParam}" class="buttontext">${uiLabelMap.CommonDetails}</a>
                          <#if gatewayResponse_has_next><hr /></#if>
                        </#list>
                      </div>
                    </#if>
                  </td>
                  <td width="10%">
                    <#if (!orderHeader.statusId.equals("ORDER_COMPLETED")) && !(orderHeader.statusId.equals("ORDER_REJECTED")) && !(orderHeader.statusId.equals("ORDER_CANCELLED"))>
                     <#if orderPaymentPreference.statusId != "PAYMENT_SETTLED">
                        <div>
                          <a href="javascript:document.CancelOrderPaymentPreference_${orderPaymentPreference.orderPaymentPreferenceId}.submit()" class="buttontext">${uiLabelMap.CommonCancel}</a>
                          <form name="CancelOrderPaymentPreference_${orderPaymentPreference.orderPaymentPreferenceId}" method="post" action="<@ofbizUrl>updateOrderPaymentPreference</@ofbizUrl>">
                            <input type="hidden" name="orderId" value="${orderId}" />
                            <input type="hidden" name="orderPaymentPreferenceId" value="${orderPaymentPreference.orderPaymentPreferenceId}" />
                            <input type="hidden" name="statusId" value="PAYMENT_CANCELLED" />
                            <input type="hidden" name="checkOutPaymentId" value="${paymentMethod.paymentMethodTypeId?if_exists}" />
                          </form>
                        </div>
                     </#if>
                    </#if>
                  </td>
                </tr>
                <#if paymentList?has_content>
                    <tr>
                    <td align="right" valign="top" width="29%">
                      <div>&nbsp;<span class="label">${uiLabelMap.AccountingInvoicePayments}</span></div>
                    </td>
                    <td width="1%">&nbsp;</td>
                      <td width="60%">
                        <div>
                            <#list paymentList as paymentMap>
                                <a href="/claccounting/control/paymentOverview?paymentId=${paymentMap.paymentId}${externalKeyParam}" class="buttontext">${paymentMap.paymentId}</a><#if paymentMap_has_next><br /></#if>
                            </#list>
                        </div>
                      </td>
                    </tr>
                </#if>
              </#if>
            <#else>
              <tr>
                <td align="right" valign="top" width="29%">
                  <div>&nbsp;<span class="label">${paymentMethodType.get("description",locale)?if_exists}</span>&nbsp;
                  <#if orderPaymentPreference.maxAmount?has_content>
                  <br />${uiLabelMap.OrderPaymentMaximumAmount}: <@ofbizCurrency amount=orderPaymentPreference.maxAmount?default(0.00) isoCode=currencyUomId/>
                  </#if>
                  </div>
                </td>
                <td width="1%">&nbsp;</td>
                <#if paymentMethodType.paymentMethodTypeId != "EXT_OFFLINE" && paymentMethodType.paymentMethodTypeId != "EXT_PAYPAL" && paymentMethodType.paymentMethodTypeId != "EXT_COD">
                  <td width="60%">
                    <div>
                      <#--CODIGOLINUX Mostrar Descripcion y Fecha de Pago -->
					  <#if paymentList?has_content>
	                            <#list paymentList as paymentMap>
	                               <br />
					${paymentMap.comments?if_exists} - Fecha:  
	                               <!--${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(paymentMap.effectiveDate, "dd/MM/yyyy", locale, timeZone)!}--> 
	                               <#if paymentMap.dueDate?has_content>
	                                ${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(paymentMap.dueDate, "dd/MM/yyyy", locale, timeZone)!}
	                                <#else>
	                                - Sin Fecha de Vencimiento
	                               </#if>
	                            </#list>
	                  </#if>
	                  
                      <#if orderPaymentPreference.maxAmount?has_content>
                         <br />${uiLabelMap.OrderPaymentMaximumAmount}: <@ofbizCurrency amount=orderPaymentPreference.maxAmount?default(0.00) isoCode=currencyUomId/>
                      </#if>
                      <!--
                      <br />&nbsp;[<#if oppStatusItem?exists>${oppStatusItem.get("description",locale)}<#else>${orderPaymentPreference.statusId}</#if>]
                      -->
                      
                      <#--CODIGOLINUX Mostrar Estado del Pago - No el orderPaymentPreference -->
                      <#if paymentList?has_content>
                      	<#list paymentList as paymentMap>
                      			<#assign oppStatusItem2 = paymentMap.getRelatedOne("StatusItem", false)>
                                - Pago: 
                                <a href="/claccounting/control/paymentOverview?paymentId=${paymentMap.paymentId}${externalKeyParam}" class="buttontext">${paymentMap.paymentId}</a>
                                [<#if oppStatusItem2?exists>${oppStatusItem2.get("description",locale)}<#else>${paymentMap.statusId}</#if>]                       
	                    </#list>
	                  </#if>
	                  
                    </div>
                    <!--
                    <div><@ofbizCurrency amount=orderPaymentPreference.maxAmount?default(0.00) isoCode=currencyUomId/>&nbsp;-&nbsp;${(orderPaymentPreference.authDate.toString())?if_exists}</div>
                    <div>&nbsp;<#if orderPaymentPreference.authRefNum?exists>(${uiLabelMap.OrderReference}: ${orderPaymentPreference.authRefNum})</#if></div>
                    -->
                  </td>
                <#else>
                  <td align="right" width="60%">
                    <a href="<@ofbizUrl>receivepayment?${paramString}</@ofbizUrl>" class="buttontext">${uiLabelMap.AccountingReceivePayment}</a>
                  </td>
                </#if>
                  <td width="10%">
                   <#if (!orderHeader.statusId.equals("ORDER_COMPLETED")) && !(orderHeader.statusId.equals("ORDER_REJECTED")) && !(orderHeader.statusId.equals("ORDER_CANCELLED"))>
                    <#if orderPaymentPreference.statusId != "PAYMENT_SETTLED">
                      <div>
                        <a href="javascript:document.CancelOrderPaymentPreference_${orderPaymentPreference.orderPaymentPreferenceId}.submit()" class="buttontext">${uiLabelMap.CommonCancel}</a>
                        <form name="CancelOrderPaymentPreference_${orderPaymentPreference.orderPaymentPreferenceId}" method="post" action="<@ofbizUrl>updateOrderPaymentPreference</@ofbizUrl>">
                          <input type="hidden" name="orderId" value="${orderId}" />
                          <input type="hidden" name="orderPaymentPreferenceId" value="${orderPaymentPreference.orderPaymentPreferenceId}" />
                          <input type="hidden" name="statusId" value="PAYMENT_CANCELLED" />
                          <input type="hidden" name="checkOutPaymentId" value="${paymentMethod.paymentMethodTypeId?if_exists}" />
                        </form>
                      </div>
                    </#if>
                   </#if>
                  </td>
                </tr>
                
                <#-- CODIGO LINUX comentado por que ya se resumio en otra linea 
                <#if paymentList?has_content>
                    <tr>
                    <td align="right" valign="top" width="29%">
                      <div>&nbsp;<span class="label">${uiLabelMap.AccountingInvoicePayments}</span></div>
                    </td>
                    <td width="1%">&nbsp;</td>
                      <td width="60%">
                        <div>
                            <#list paymentList as paymentMap>
                                <a href="/claccounting/control/paymentOverview?paymentId=${paymentMap.paymentId}${externalKeyParam}" class="buttontext">${paymentMap.paymentId}</a><#if paymentMap_has_next><br /></#if>
                            </#list>
                        </div>
                      </td>
                    </tr>
                </#if>
                -->
            </#if>
          <#else>
            <#if paymentMethod.paymentMethodTypeId?if_exists == "CREDIT_CARD">
              <#assign gatewayResponses = orderPaymentPreference.getRelated("PaymentGatewayResponse", null, null, false)>
              <#assign creditCard = paymentMethod.getRelatedOne("CreditCard", false)?if_exists>
              <#if creditCard?has_content>
                <#assign pmBillingAddress = creditCard.getRelatedOne("PostalAddress", false)?if_exists>
              </#if>
              <tr>
                <td align="right" valign="top" width="29%">
                  <div>&nbsp;<span class="label">${uiLabelMap.AccountingCreditCard}</span>
                  <#if orderPaymentPreference.maxAmount?has_content>
                     <br />${uiLabelMap.OrderPaymentMaximumAmount}: <@ofbizCurrency amount=orderPaymentPreference.maxAmount?default(0.00) isoCode=currencyUomId/>
                  </#if>
                  </div>
                </td>
                <td width="1%">&nbsp;</td>
                <td valign="top" width="60%">
                  <div>
                    <#if creditCard?has_content>
                      <#if creditCard.companyNameOnCard?exists>${creditCard.companyNameOnCard}<br /></#if>
                      <#if creditCard.titleOnCard?has_content>${creditCard.titleOnCard}&nbsp;</#if>
                      ${creditCard.firstNameOnCard?default("N/A")}&nbsp;
                      <#if creditCard.middleNameOnCard?has_content>${creditCard.middleNameOnCard}&nbsp;</#if>
                      ${creditCard.lastNameOnCard?default("N/A")}
                      <#if creditCard.suffixOnCard?has_content>&nbsp;${creditCard.suffixOnCard}</#if>
                      <br />

                      <#if security.hasEntityPermission("PAY_INFO", "_VIEW", session) || security.hasEntityPermission("ACCOUNTING", "_VIEW", session)>
                        ${creditCard.cardType}
                        <@maskSensitiveNumber cardNumber=creditCard.cardNumber?if_exists/>
                        ${creditCard.expireDate}
                        &nbsp;[<#if oppStatusItem?exists>${oppStatusItem.get("description",locale)}<#else>${orderPaymentPreference.statusId}</#if>]
                      <#else>
                        ${Static["org.ofbiz.party.contact.ContactHelper"].formatCreditCard(creditCard)}
                        &nbsp;[<#if oppStatusItem?exists>${oppStatusItem.get("description",locale)}<#else>${orderPaymentPreference.statusId}</#if>]
                      </#if>
                      <br />

                      <#-- Authorize and Capture transactions -->
                      <div>
                        <#if orderPaymentPreference.statusId != "PAYMENT_SETTLED">
                          <a href="/claccounting/control/AuthorizeTransaction?orderId=${orderId?if_exists}&amp;orderPaymentPreferenceId=${orderPaymentPreference.orderPaymentPreferenceId}${externalKeyParam}" class="buttontext">${uiLabelMap.AccountingAuthorize}</a>
                        </#if>
                        <#if orderPaymentPreference.statusId == "PAYMENT_AUTHORIZED">
                          <a href="/claccounting/control/CaptureTransaction?orderId=${orderId?if_exists}&amp;orderPaymentPreferenceId=${orderPaymentPreference.orderPaymentPreferenceId}${externalKeyParam}" class="buttontext">${uiLabelMap.AccountingCapture}</a>
                        </#if>
                      </div>
                    <#else>
                      ${uiLabelMap.CommonInformation} ${uiLabelMap.CommonNot} ${uiLabelMap.CommonAvailable}
                    </#if>
                  </div>
                  <#if gatewayResponses?has_content>
                    <div>
                      <hr />
                      <#list gatewayResponses as gatewayResponse>
                        <#assign transactionCode = gatewayResponse.getRelatedOne("TranCodeEnumeration", false)>
                        ${(transactionCode.get("description",locale))?default("Unknown")}:
                        <#if gatewayResponse.transactionDate?has_content>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(gatewayResponse.transactionDate, "", locale, timeZone)!} </#if>
                        <@ofbizCurrency amount=gatewayResponse.amount isoCode=currencyUomId/><br />
                        (<span class="label">${uiLabelMap.OrderReference}</span>&nbsp;${gatewayResponse.referenceNum?if_exists}
                        <span class="label">${uiLabelMap.OrderAvs}</span>&nbsp;${gatewayResponse.gatewayAvsResult?default("N/A")}
                        <span class="label">${uiLabelMap.OrderScore}</span>&nbsp;${gatewayResponse.gatewayScoreResult?default("N/A")})
                        <a href="/claccounting/control/ViewGatewayResponse?paymentGatewayResponseId=${gatewayResponse.paymentGatewayResponseId}${externalKeyParam}" class="buttontext">${uiLabelMap.CommonDetails}</a>
                        <#if gatewayResponse_has_next><hr /></#if>
                      </#list>
                    </div>
                  </#if>
                </td>
                <td width="10%">
                  <#if (!orderHeader.statusId.equals("ORDER_COMPLETED")) && !(orderHeader.statusId.equals("ORDER_REJECTED")) && !(orderHeader.statusId.equals("ORDER_CANCELLED"))>
                   <#if orderPaymentPreference.statusId != "PAYMENT_SETTLED">
                      <a href="javascript:document.CancelOrderPaymentPreference_${orderPaymentPreference.orderPaymentPreferenceId}.submit()" class="buttontext">${uiLabelMap.CommonCancel}</a>
                      <form name="CancelOrderPaymentPreference_${orderPaymentPreference.orderPaymentPreferenceId}" method="post" action="<@ofbizUrl>updateOrderPaymentPreference</@ofbizUrl>">
                        <input type="hidden" name="orderId" value="${orderId}" />
                        <input type="hidden" name="orderPaymentPreferenceId" value="${orderPaymentPreference.orderPaymentPreferenceId}" />
                        <input type="hidden" name="statusId" value="PAYMENT_CANCELLED" />
                        <input type="hidden" name="checkOutPaymentId" value="${paymentMethod.paymentMethodTypeId?if_exists}" />
                      </form>
                   </#if>
                  </#if>
                </td>
              </tr>
            <#elseif paymentMethod.paymentMethodTypeId?if_exists == "EFT_ACCOUNT">
              <#assign eftAccount = paymentMethod.getRelatedOne("EftAccount", false)>
              <#if eftAccount?has_content>
                <#assign pmBillingAddress = eftAccount.getRelatedOne("PostalAddress", false)?if_exists>
              </#if>
              <tr>
                <td align="right" valign="top" width="29%">
                  <div>&nbsp;<span class="label">${uiLabelMap.AccountingEFTAccount}</span>
                  <#if orderPaymentPreference.maxAmount?has_content>
                  <br />${uiLabelMap.OrderPaymentMaximumAmount}: <@ofbizCurrency amount=orderPaymentPreference.maxAmount?default(0.00) isoCode=currencyUomId/>
                  </#if>
                  </div>
                </td>
                <td width="1%">&nbsp;</td>
                <td valign="top" width="60%">
                  <div>
                    <#if eftAccount?has_content>
                      ${eftAccount.nameOnAccount?if_exists}<br />
                      <#if eftAccount.companyNameOnAccount?exists>${eftAccount.companyNameOnAccount}<br /></#if>
                      ${uiLabelMap.AccountingBankName}: ${eftAccount.bankName}, ${eftAccount.routingNumber}<br />
                      ${uiLabelMap.AccountingAccount}#: ${eftAccount.accountNumber}
                    <#else>
                      ${uiLabelMap.CommonInformation} ${uiLabelMap.CommonNot} ${uiLabelMap.CommonAvailable}
                    </#if>
                  </div>
                </td>
                <td width="10%">
                  <#if (!orderHeader.statusId.equals("ORDER_COMPLETED")) && !(orderHeader.statusId.equals("ORDER_REJECTED")) && !(orderHeader.statusId.equals("ORDER_CANCELLED"))>
                   <#if orderPaymentPreference.statusId != "PAYMENT_SETTLED">
                      <a href="javascript:document.CancelOrderPaymentPreference_${orderPaymentPreference.orderPaymentPreferenceId}.submit()" class="buttontext">${uiLabelMap.CommonCancel}</a>
                      <form name="CancelOrderPaymentPreference_${orderPaymentPreference.orderPaymentPreferenceId}" method="post" action="<@ofbizUrl>updateOrderPaymentPreference</@ofbizUrl>">
                        <input type="hidden" name="orderId" value="${orderId}" />
                        <input type="hidden" name="orderPaymentPreferenceId" value="${orderPaymentPreference.orderPaymentPreferenceId}" />
                        <input type="hidden" name="statusId" value="PAYMENT_CANCELLED" />
                        <input type="hidden" name="checkOutPaymentId" value="${paymentMethod.paymentMethodTypeId?if_exists}" />
                      </form>
                   </#if>
                  </#if>
                </td>
              </tr>
              <#if paymentList?has_content>
                <tr>
                <td align="right" valign="top" width="29%">
                  <div>&nbsp;<span class="label">${uiLabelMap.AccountingInvoicePayments}</span></div>
                </td>
                <td width="1%">&nbsp;</td>
                  <td width="60%">
                    <div>
                        <#list paymentList as paymentMap>
                            <a href="/claccounting/control/paymentOverview?paymentId=${paymentMap.paymentId}${externalKeyParam}" class="buttontext">${paymentMap.paymentId}</a><#if paymentMap_has_next><br /></#if>
                        </#list>
                    </div>
                  </td>
                </tr>
              </#if>
            <#elseif paymentMethod.paymentMethodTypeId?if_exists == "GIFT_CARD">
              <#assign giftCard = paymentMethod.getRelatedOne("GiftCard", false)>
              <#if giftCard?exists>
                <#assign pmBillingAddress = giftCard.getRelatedOne("PostalAddress", false)?if_exists>
              </#if>
              <tr>
                <td align="right" valign="top" width="29%">
                  <div>&nbsp;<span class="label">${uiLabelMap.OrderGiftCard}</span>
                  <#if orderPaymentPreference.maxAmount?has_content>
                  <br />${uiLabelMap.OrderPaymentMaximumAmount}: <@ofbizCurrency amount=orderPaymentPreference.maxAmount?default(0.00) isoCode=currencyUomId/>
                  </#if>
                  </div>
                </td>
                <td width="1%">&nbsp;</td>
                <td valign="top" width="60%">
                  <div>
                    <#if giftCard?has_content>
                      <#if security.hasEntityPermission("PAY_INFO", "_VIEW", session) || security.hasEntityPermission("ACCOUNTING", "_VIEW", session)>
                        ${giftCard.cardNumber?default("N/A")} [${giftCard.pinNumber?default("N/A")}]
                        &nbsp;[<#if oppStatusItem?exists>${oppStatusItem.get("description",locale)}<#else>${orderPaymentPreference.statusId}</#if>]
                      <#else>
                      <@maskSensitiveNumber cardNumber=giftCard.cardNumber?if_exists/>
                      <#if !cardNumberDisplay?has_content>N/A</#if>
                        &nbsp;[<#if oppStatusItem?exists>${oppStatusItem.get("description",locale)}<#else>${orderPaymentPreference.statusId}</#if>]
                      </#if>
                    <#else>
                      ${uiLabelMap.CommonInformation} ${uiLabelMap.CommonNot} ${uiLabelMap.CommonAvailable}
                    </#if>
                  </div>
                </td>
                <td width="10%">
                  <#if (!orderHeader.statusId.equals("ORDER_COMPLETED")) && !(orderHeader.statusId.equals("ORDER_REJECTED")) && !(orderHeader.statusId.equals("ORDER_CANCELLED"))>
                   <#if orderPaymentPreference.statusId != "PAYMENT_SETTLED">
                      <a href="javascript:document.CancelOrderPaymentPreference_${orderPaymentPreference.orderPaymentPreferenceId}.submit()" class="buttontext">${uiLabelMap.CommonCancel}</a>
                      <form name="CancelOrderPaymentPreference_${orderPaymentPreference.orderPaymentPreferenceId}" method="post" action="<@ofbizUrl>updateOrderPaymentPreference</@ofbizUrl>">
                        <input type="hidden" name="orderId" value="${orderId}" />
                        <input type="hidden" name="orderPaymentPreferenceId" value="${orderPaymentPreference.orderPaymentPreferenceId}" />
                        <input type="hidden" name="statusId" value="PAYMENT_CANCELLED" />
                        <input type="hidden" name="checkOutPaymentId" value="${paymentMethod.paymentMethodTypeId?if_exists}" />
                      </form>
                   </#if>
                  </#if>
                </td>
              </tr>
              <#if paymentList?has_content>
                <tr>
                <td align="right" valign="top" width="29%">
                  <div>&nbsp;<span class="label">${uiLabelMap.AccountingInvoicePayments}</span></div>
                </td>
                <td width="1%">&nbsp;</td>
                  <td width="60%">
                    <div>
                        <#list paymentList as paymentMap>
                            <a href="/claccounting/control/paymentOverview?paymentId=${paymentMap.paymentId}${externalKeyParam}" class="buttontext">${paymentMap.paymentId}</a><#if paymentMap_has_next><br /></#if>
                        </#list>
                    </div>
                  </td>
                </tr>
              </#if>
            </#if>
          </#if>
          <#if pmBillingAddress?has_content>
            <tr><td>&nbsp;</td><td>&nbsp;</td><td colspan="3"><hr /></td></tr>
            <tr>
              <td align="right" valign="top" width="29%">&nbsp;</td>
              <td width="1%">&nbsp;</td>
              <td valign="top" width="60%">
                <div>
                  <#if pmBillingAddress.toName?has_content><span class="label">${uiLabelMap.CommonTo}</span>&nbsp;${pmBillingAddress.toName}<br /></#if>
                  <#if pmBillingAddress.attnName?has_content><span class="label">${uiLabelMap.CommonAttn}</span>&nbsp;${pmBillingAddress.attnName}<br /></#if>
                  ${pmBillingAddress.address1}<br />
                  <#if pmBillingAddress.address2?has_content>${pmBillingAddress.address2}<br /></#if>
                  ${pmBillingAddress.city}<#if pmBillingAddress.stateProvinceGeoId?has_content>, ${pmBillingAddress.stateProvinceGeoId} </#if>
                  ${pmBillingAddress.postalCode?if_exists}<br />
                  ${pmBillingAddress.countryGeoId?if_exists}
                </div>
              </td>
              <td width="10%">&nbsp;</td>
            </tr>
            <#if paymentList?has_content>
            <tr>
            <td align="right" valign="top" width="29%">
              <div>&nbsp;<span class="label">${uiLabelMap.AccountingInvoicePayments}</span></div>
            </td>
            <td width="1%">&nbsp;</td>
              <td width="60%">
                <div>
                    <#list paymentList as paymentMap>
                        <a href="/claccounting/control/paymentOverview?paymentId=${paymentMap.paymentId}${externalKeyParam}" class="buttontext">${paymentMap.paymentId}</a><#if paymentMap_has_next><br /></#if>
                    </#list>
                </div>
              </td>
            </tr>
            </#if>
          </#if>
        </#list>

        <#if customerPoNumber?has_content>
          <tr><td colspan="4"><hr /></td></tr>
          <tr>
            <td align="right" valign="top" width="29%"><span class="label">${uiLabelMap.OrderPONumber}</span></td>
            <td width="1%">&nbsp;</td>
            <td valign="top" width="60%">${customerPoNumber?if_exists}</td>
            <td width="10%">&nbsp;</td>
          </tr>
        </#if>

        <#-- invoices -->
        <!--
        <#if invoices?has_content>
          <tr><td colspan="4"><hr /></td></tr>
          <tr>
            <td align="right" valign="top" width="29%">&nbsp;<span class="label">${uiLabelMap.OrderInvoices}</span></td>
            <td width="1%">&nbsp;</td>
            <td valign="top" width="60%">
              <#list invoices as invoice>
                <div>${uiLabelMap.CommonNbr}<a href="/claccounting/control/invoiceOverview?invoiceId=${invoice}${externalKeyParam}" class="buttontext">${invoice} 
                 <#if invoice.statusId?has_content>
                ${invoice.statusId}
                </#if>
                </a>
                (<a target="_BLANK" href="/claccounting/control/invoice.pdf?invoiceId=${invoice}${externalKeyParam}" class="buttontext">PDF</a>)</div>
              </#list>
            </td>
            <td width="10%">&nbsp;</td>
          </tr>
        </#if>
        -->
        
        <#-- ------------------------------------------------ invoices List---------------------------------------------- -->
        <#list paymentList as paymentMap>
	        <#assign paymentAplicationList = paymentMap.getRelated("PaymentApplication", null, null, false)>
	        <#break>
        </#list>

		<#if paymentAplicationList?has_content>
        <#list paymentAplicationList as paymentAplication>
        <#assign invoicesList = paymentAplication.getRelated("Invoice", null, null, false)>
        </#list>
        <#if invoicesList?has_content>
          <tr><td colspan="4"><hr /></td></tr>
          <tr>
            <td align="right" valign="top" width="29%">&nbsp;<span class="label">${uiLabelMap.OrderInvoices}</span></td>
            <td width="1%">&nbsp;</td>
            <td valign="top" width="60%">
              <#list invoicesList as invoiceMap>
                <#assign statusItem = invoiceMap.getRelatedOne("StatusItem", false)>
                <#if invoiceMap.statusId?has_content> 
	                Estado: ${statusItem.get("description",locale)} <!-- ${statusItem.statusId}-->
	                <#if invoiceMap.statusId=="INVOICE_IN_PROCESS">
              		<form name="setInvoice" method="post" action="<@ofbizUrl>updateInvoiceFromOrder</@ofbizUrl>">
              		    <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
              	 		<input type="hidden" name="invoiceId" value="${invoiceMap.invoiceId}" />
              	 
		                <div>
		                Condición
		                <select name="condicionInvoice">
	                        <option value="CONTADO" <#if (invoiceMap.condicionInvoice)?if_exists == "CONTADO">selected="selected" </#if>>CONTADO</option>
	             			<option value="CREDITO" <#if (invoiceMap.condicionInvoice)?if_exists == "CREDITO">selected="selected" </#if>>CREDITO</option>
	             		</select>
	             		</div>
		                <div>
		                Timbrado: <input type="text" size="12" maxlength="12" name="timbradoInvoice" value="12345678"/>
		                </div>
		                <div>
		                Nro.Factura: <input type="text" size="2" maxlength="3" name="entInvoice" value="${invoiceMap.entInvoice?if_exists}"/><input type="text" size="2" maxlength="3" name="emiInvoice" value="${invoiceMap.emiInvoice?if_exists}"/><input type="text"size="8" maxlength="12" name="nroInvoice" value="${invoiceMap.nroInvoice?if_exists}"/>
		                </div>
		                
	                    <input type="submit" class="smallSubmit" value="${uiLabelMap.CommonUpdate}"/>
                	</form>
                	<#else>
                	<div> Condición: ${invoiceMap.condicionInvoice} </div>
		            <div> Timbrado: ${invoiceMap.timbradoInvoice} </div>
		            <div> Nro.Factura: ${invoiceMap.entInvoice}-${invoiceMap.emiInvoice}-${invoiceMap.nroInvoice}</div>
	                </#if>
                </#if>

                <!-- <div><a href="/claccounting/control/updateInvoice?invoiceId=${invoiceMap.invoiceId}${externalKeyParam}" class="buttontext">Actualizar -->
                </a> </div>
                <div>${uiLabelMap.CommonNbr}<a target="_BLANK" href="/claccounting/control/invoiceOverview?invoiceId=${invoiceMap.invoiceId}${externalKeyParam}" class="buttontext">${invoiceMap.invoiceId} 
                </a>                  

                (<a target="_BLANK" href="/claccounting/control/invoice.pdf?invoiceId=${invoiceMap.invoiceId}${externalKeyParam}" class="buttontext">PDF</a>)</div>
              </#list>
            </td>
            <td width="10%">&nbsp;</td>
          </tr>
        </#if>
        </#if>
   <#else>
    <tr>
     <td colspan="4" align="center">${uiLabelMap.OrderNoOrderPaymentPreferences}</td>
    </tr>
   </#if>
   <#if (!orderHeader.statusId.equals("ORDER_COMPLETED")) && !(orderHeader.statusId.equals("ORDER_REJECTED")) && !(orderHeader.statusId.equals("ORDER_CANCELLED")) && (paymentMethodValueMaps?has_content)>
   <tr><td colspan="4"><hr /></td></tr>
   <tr><td colspan="4">
   <form name="addPaymentMethodToOrder" method="post" action="<@ofbizUrl>addPaymentMethodToOrder</@ofbizUrl>">
   <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
   <table class="basic-table" cellspacing='0'>
   <tr>
      <td width="29%" align="right" nowrap="nowrap"><span class="label">${uiLabelMap.AccountingPaymentMethod}</span></td>
      <td width="1%">&nbsp;</td>
      <td width="60%" nowrap="nowrap">
         <select name="paymentMethodId">
           <#list paymentMethodValueMaps as paymentMethodValueMap>
             <#assign paymentMethod = paymentMethodValueMap.paymentMethod/>
             <option value="${paymentMethod.get("paymentMethodId")?if_exists}">
               <#if "CREDIT_CARD" == paymentMethod.paymentMethodTypeId>
                 <#assign creditCard = paymentMethodValueMap.creditCard/>
                 <#if (creditCard?has_content)>
                   <#if security.hasEntityPermission("PAY_INFO", "_VIEW", session) || security.hasEntityPermission("ACCOUNTING", "_VIEW", session)>
                     ${creditCard.cardType?if_exists} <@maskSensitiveNumber cardNumber=creditCard.cardNumber?if_exists/> ${creditCard.expireDate?if_exists}
                   <#else>
                     ${Static["org.ofbiz.party.contact.ContactHelper"].formatCreditCard(creditCard)}
                   </#if>
                 </#if>
               <#else>
                 ${paymentMethod.paymentMethodTypeId?if_exists}
                 <#if paymentMethod.description?exists>${paymentMethod.description}</#if>
                   (${paymentMethod.paymentMethodId})
                 </#if>
               </option>
           </#list>
         </select>
      </td>
      <td width="10%">&nbsp;</td>
   </tr>
   <#assign openAmount = orderReadHelper.getOrderOpenAmount()>
   <tr>
      <td width="29%" align="right"><span class="label">${uiLabelMap.AccountingAmount}</span></td>
      <td width="1%">&nbsp;</td>
      <td width="60%" nowrap="nowrap">
         <input type="text" name="maxAmount" value="${openAmount}"/>
      </td>
      <td width="10%">&nbsp;</td>
   </tr>
   <tr>
      <td align="right" valign="top" width="29%">&nbsp;</td>
      <td width="1%">&nbsp;</td>
      <td valign="top" width="60%">
        <input type="submit" value="${uiLabelMap.CommonAdd}" class="smallSubmit"/>
      </td>
      <td width="10%">&nbsp;</td>
   </tr>
   </table>
   </form>
   </td></tr>
</#if>
</#if>
</table>
</div>
</div>
