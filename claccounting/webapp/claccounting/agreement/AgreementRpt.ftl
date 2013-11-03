<#assign birt = JspTaglibs["/WEB-INF/birt.tld"]/>


<@birt.report id="birtReport"
    reportDesign="component://birt/webapp/accounting/reports/ContratoVenta2.rptdesign"
    baseURL="/birt"
    height="700"
    width="900"
    format="html"
    isHostPage="false"
    pageNum="2"
    showParameterPage="false">
<#--<@birt.param name="agreementId" value="${requestParameters.agreementId}">-->
<@birt.param name="agreementId" value="${requestParameters.agreementId}">

</@birt.param>
</@birt.report>