<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PODCompletionCertificate.aspx.cs" Inherits="POD.Templates.Certificates.PODCompletionCertificate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link type="text/css" rel="stylesheet" href="~/Templates/Styles/PODCertificateStyles.css" />
   
</head>
<body>
    <form id="form1" runat="server">
    <div class="CertificateContainer">
        <div class="CertificateContent">
            <h1>Certificate of Completion</h1>
            <p class="Italicize">
                This certificate is awarded to:
            </p>
            <h2><asp:Label ID="LabelRecipient" runat="server"></asp:Label></h2>
            <p class="Italicize">
                in recognition of
            </p>
            <h3>Successful Completion of the Prodigy Program</h3>
            
            <div class="SignatureBlock DateBlock">
                <p>
                    Date
                </p>
            </div>
            
            <div class="SignatureBlock">
                <p>
                    Signature of Admin Staff Person
                </p>
            </div>
            
            <div class="SignatureBlock DateBlock">
                <p>
                    Date
                </p>
            </div>
            
            <div class="SignatureBlock">
                <p>
                    Signature of Site Manager
                </p>
            </div>
            
        </div>
    </div>
    </form>
</body>
</html>
