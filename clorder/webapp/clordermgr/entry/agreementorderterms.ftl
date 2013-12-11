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

<table border="0" width="100%" cellspacing="0" cellpadding="0" class="boxoutside">
    <tr>
        <td width="100%">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="boxbottom">
                <tr>
                    <td>
                        <#-- checkoutsetupform is used for the order entry "continue" link -->
                        <form method="post" action="<@ofbizUrl>finalizeOrder</@ofbizUrl>" name="checkoutsetupform">
                            <input type="hidden" name="finalizeMode" value="term" />
                        </form>
                        <#if orderTerms?has_content && parameters.createNew?default('') != 'Y'>
                            <table class="basic-table hover-bar">
                                <tr class="header-row">
                                    <td>${uiLabelMap.OrderOrderTermType}</td>
                                    <td align="center">${uiLabelMap.OrderOrderTermValue}</td>
                                    <td align="center">${uiLabelMap.OrderOrderTermDays}</td>
                                    <td>${uiLabelMap.CommonDescription}</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <#list orderTerms as orderTerm>
                                    <tr <#if orderTerm_index % 2 != 0>class="alternate-row"</#if> >
                                        <td nowrap="nowrap">${orderTerm.getRelatedOne('TermType', false).get('description', locale)}</td>
                                        <td align="center">${orderTerm.termValue?if_exists}</td>
                                        <td align="center">${orderTerm.termDays?if_exists}</td>
                                        <td nowrap="nowrap">${orderTerm.textValue?if_exists}</td>
                                        <td align="right">
                                            <a href="<@ofbizUrl>setOrderTerm?termIndex=${orderTerm_index}&amp;createNew=Y</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonUpdate}</a>
                                            <a href="<@ofbizUrl>removeCartOrderTerm?termIndex=${orderTerm_index}</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonRemove}</a>
                                        </td>
                                    </tr>
                                </#list>
                                <tr>
                                    <td colspan="5">
                                        <a href="<@ofbizUrl>setOrderTerm?createNew=Y</@ofbizUrl>" class="buttontext">${uiLabelMap.CommonCreateNew}</a>
                                    </td>
                                </tr>
                            </table>
                        <#else>
                            <form method="post" action="<@ofbizUrl>addOrderTerm</@ofbizUrl>" name="termform">
                                <input type="hidden" name="termIndex" value="${termIndex?if_exists}" />
                                <table class="basic-table"
                                    <tr>
                                    <td width="25%" align="right" valign="top">
                                        1. Referencia Personal/Comercial
                                    </td>
                                    <td width="5">&nbsp;</td>
                                    <td width="25%">
                                            <input type="text" size="40" maxlength="255" name="textValueRef1" value="${textValueRef1?if_exists}" />
                                        </td>
                                    <td width="5">&nbsp;</td>
                                    <td width="5%" align="right" valign="top">
                                         Tel.
                                    </td>
                                    <td width="5">&nbsp;</td>
                                    <td width="15%">
                                        <input type="text" size="30" maxlength="60" name="termValueRef1" value="${termValueRef1?if_exists}" />
                                    </td>
                                    <td width="30%">
                                    </td>
                                    </tr>
                                    
                                    <tr>
                                    <td width="25%" align="right" valign="top">
                                        2. Referencia Personal/Comercial
                                    </td>
                                    <td width="5">&nbsp;</td>
                                    <td width="25%">
                                            <input type="text" size="40" maxlength="255" name="textValueRef2" value="${textValueRef2?if_exists}" />
                                        </td>
                                    <td width="5">&nbsp;</td>
                                    <td width="5%" align="right" valign="top">
                                         Tel.
                                    </td>
                                    <td width="5">&nbsp;</td>
                                    <td width="15%">
                                        <input type="text" size="30" maxlength="60" name="termValueRef2" value="${termValueRef2?if_exists}" />
                                    </td>
                                    <td width="30%">
                                    </td>
                                    </tr>
                                    
                                    <tr>
                                        <td width="25%" align="right" valign="top">&nbsp;</td>
                                        <td width="5">&nbsp;</td>
                                        <td width="25%">
                                            <input type="submit" class="smallSubmit" value="Aceptar" />
                                        </td>
                                        <td width="5%" align="right" valign="top">&nbsp;</td>
                                        <td width="5">&nbsp;</td>
                                        <td width="15%">
                                        </td>
                                        <td width="30%">
                                        </td>
                                    </tr>
                                </table>
                                <table class="basic-table">
                                     <tr>
                                        <td width="26%" align="right" valign="top">
                                            Cuotas
                                        </td>
                                        <td width="5">&nbsp;</td>
                                        <td width="74%">
                                            <input type="text" size="30" maxlength="60" name="termValueCuotas" value="${termValueCuotas?if_exists}" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="26%" align="right" valign="top">
                                            Anticipo
                                        </td>
                                        <td width="5">&nbsp;</td>
                                        <td width="74%">
                                            <input type="text" size="30" maxlength="60" name="termValueAnticipo" value="${termValueAnticipo?if_exists}" />
                                        </td>
                                    </tr>
                                </table>
                                
                            </form>
                        </#if>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
